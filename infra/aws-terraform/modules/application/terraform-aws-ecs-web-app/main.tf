module "default_label" {
  source    = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=tags/0.1.4"
  name      = "${var.name}"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
}

module "ecr" {
  source     = "../terraform-aws-ecr"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  attributes = "${compact(concat(var.attributes, list("ecr")))}"
}

resource "aws_route53_record" "dns" {
  zone_id = "${var.zone_id}"
  name    = "${var.dns_name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${module.alb.alb_dns_name}"]
}

resource "aws_security_group" "app_traffic" {
  name        = "${var.name}-${var.stage}-app-traffic"
  description = "Allow app inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = "${var.container_port}"
    to_port         = "${var.container_port}"
    protocol        = "tcp"
    security_groups = ["${module.alb.security_group_id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = "true"
  }
}

module "alb" {
  source             = "../terraform-aws-alb"
  namespace          = "${var.namespace}"
  stage              = "${var.stage}"
  name               = "${var.name}"
  vpc_id             = "${var.vpc_id}"
  access_logs_region = "${var.region}"
  subnet_ids         = ["${var.alb_subnet_ids}"]
  internal           = "${var.internal}"

  https_enabled   = "true"
  certificate_arn = "${var.certificate_arn}"
}

resource "aws_cloudwatch_log_group" "app" {
  name = "${module.default_label.id}"
  tags = "${module.default_label.tags}"
}

module "alb_ingress" {
  source              = "../terraform-aws-alb-ingress"
  name                = "${var.name}"
  namespace           = "${var.namespace}"
  stage               = "${var.stage}"
  attributes          = "${var.attributes}"
  vpc_id              = "${var.vpc_id}"
  listener_arns       = "${module.alb.listener_arns}"
  http_listener_arn   = "${module.alb.http_listener_arn}"
  https_listener_arn  = "${module.alb.https_listener_arn}"
  listener_arns_count = "${length(split(",", "module.alb.listener_arns"))}"
  health_check_path   = "${var.alb_ingress_healthcheck_path}"
  paths               = ["${var.alb_ingress_paths}"]
  priority            = "${var.alb_ingress_listener_priority}"
  hosts               = ["${var.alb_ingress_hosts}"]
  port                = "${var.container_port}"
}

module "container_definition" {
  source                       = "../terraform-aws-ecs-container-definition"
  container_name               = "${module.default_label.id}"
  container_image              = "${module.ecr.registry_url}"
  container_memory             = "${var.container_memory}"
  container_memory_reservation = "${var.container_memory_reservation}"
  container_cpu                = "${var.container_cpu}"
  healthcheck                  = "${var.healthcheck}"
  environment                  = "${var.environment}"
  port_mappings                = "${var.port_mappings}"

  log_options = {
    "awslogs-region"        = "${var.aws_logs_region}"
    "awslogs-group"         = "${aws_cloudwatch_log_group.app.name}"
    "awslogs-stream-prefix" = "${var.name}"
  }
}

module "ecs_alb_service_task" {
  source                    = "../terraform-aws-ecs-alb-service-task"
  name                      = "${var.name}"
  namespace                 = "${var.namespace}"
  stage                     = "${var.stage}"
  alb_target_group_arn      = "${module.alb_ingress.target_group_arn}"
  container_definition_json = "${module.container_definition.json}"
  container_name            = "${module.default_label.id}"
  desired_count             = "${var.desired_count}"
  task_cpu                  = "${var.container_cpu}"
  task_memory               = "${var.container_memory}"
  ecr_repository_name       = "${module.ecr.repository_name}"
  ecs_cluster_arn           = "${var.ecs_cluster_arn}"
  launch_type               = "${var.launch_type}"
  vpc_id                    = "${var.vpc_id}"
  security_group_ids        = "${module.alb.security_group_id}"
  private_subnet_ids        = ["${var.ecs_private_subnet_ids}"]
  container_port            = "${var.container_port}"
}

module "ecs_codepipeline" {
  enabled          = "${var.codepipeline_enabled}"
  source           = "../terraform-aws-ecs-codepipeline"
  name             = "${var.name}"
  namespace        = "${var.namespace}"
  stage            = "${var.stage}"
  image_repo_name  = "${module.ecr.repository_name}"
  service_name     = "${module.ecs_alb_service_task.service_name}"
  ecs_cluster_name = "${var.ecs_cluster_name}"
  privileged_mode  = "true"

  environment_variables = [{
    "name" = "CONTAINER_NAME"

    "value" = "${module.default_label.id}"
  }]
}

module "autoscaling" {
  enabled               = "${var.autoscaling_enabled}"
  source                = "git::https://github.com/cloudposse/terraform-aws-ecs-cloudwatch-autoscaling.git?ref=tags/0.1.0"
  name                  = "${var.name}"
  namespace             = "${var.namespace}"
  stage                 = "${var.stage}"
  service_name          = "${module.ecs_alb_service_task.service_name}"
  cluster_name          = "${var.ecs_cluster_name}"
  min_capacity          = "${var.autoscaling_min_capacity}"
  max_capacity          = "${var.autoscaling_max_capacity}"
  scale_down_adjustment = "${var.autoscaling_scale_down_adjustment}"
  scale_down_cooldown   = "${var.autoscaling_scale_down_cooldown}"
  scale_up_adjustment   = "${var.autoscaling_scale_up_adjustment}"
  scale_up_cooldown     = "${var.autoscaling_scale_up_cooldown}"
}

locals {
  cpu_utilization_high_alarm_actions    = "${var.autoscaling_enabled == "true" && var.autoscaling_dimension == "cpu" ? module.autoscaling.scale_up_policy_arn : ""}"
  cpu_utilization_low_alarm_actions     = "${var.autoscaling_enabled == "true" && var.autoscaling_dimension == "cpu" ? module.autoscaling.scale_down_policy_arn : ""}"
  memory_utilization_high_alarm_actions = "${var.autoscaling_enabled == "true" && var.autoscaling_dimension == "memory" ? module.autoscaling.scale_up_policy_arn : ""}"
  memory_utilization_low_alarm_actions  = "${var.autoscaling_enabled == "true" && var.autoscaling_dimension == "memory" ? module.autoscaling.scale_down_policy_arn : ""}"
}

module "ecs_alarms" {
  source     = "../terraform-aws-ecs-cloudwatch-sns-alarms"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"

  enabled      = "${var.ecs_alarms_enabled}"
  cluster_name = "${var.ecs_cluster_name}"
  service_name = "${module.ecs_alb_service_task.service_name}"

  cpu_utilization_high_threshold          = "${var.ecs_alarms_cpu_utilization_high_threshold}"
  cpu_utilization_high_evaluation_periods = "${var.ecs_alarms_cpu_utilization_high_evaluation_periods}"
  cpu_utilization_high_period             = "${var.ecs_alarms_cpu_utilization_high_period}"
  cpu_utilization_high_alarm_actions      = "${compact(concat(var.ecs_alarms_cpu_utilization_high_alarm_actions, list(local.cpu_utilization_high_alarm_actions)))}"
  cpu_utilization_high_ok_actions         = "${var.ecs_alarms_cpu_utilization_high_ok_actions}"

  cpu_utilization_low_threshold          = "${var.ecs_alarms_cpu_utilization_low_threshold}"
  cpu_utilization_low_evaluation_periods = "${var.ecs_alarms_cpu_utilization_low_evaluation_periods}"
  cpu_utilization_low_period             = "${var.ecs_alarms_cpu_utilization_low_period}"
  cpu_utilization_low_alarm_actions      = "${compact(concat(var.ecs_alarms_cpu_utilization_low_alarm_actions, list(local.cpu_utilization_low_alarm_actions)))}"
  cpu_utilization_low_ok_actions         = "${var.ecs_alarms_cpu_utilization_low_ok_actions}"

  memory_utilization_high_threshold          = "${var.ecs_alarms_memory_utilization_high_threshold}"
  memory_utilization_high_evaluation_periods = "${var.ecs_alarms_memory_utilization_high_evaluation_periods}"
  memory_utilization_high_period             = "${var.ecs_alarms_memory_utilization_high_period}"
  memory_utilization_high_alarm_actions      = "${compact(concat(var.ecs_alarms_memory_utilization_high_alarm_actions, list(local.memory_utilization_high_alarm_actions)))}"
  memory_utilization_high_ok_actions         = "${var.ecs_alarms_memory_utilization_high_ok_actions}"

  memory_utilization_low_threshold          = "${var.ecs_alarms_memory_utilization_low_threshold}"
  memory_utilization_low_evaluation_periods = "${var.ecs_alarms_memory_utilization_low_evaluation_periods}"
  memory_utilization_low_period             = "${var.ecs_alarms_memory_utilization_low_period}"
  memory_utilization_low_alarm_actions      = "${compact(concat(var.ecs_alarms_memory_utilization_low_alarm_actions, list(local.memory_utilization_low_alarm_actions)))}"
  memory_utilization_low_ok_actions         = "${var.ecs_alarms_memory_utilization_low_ok_actions}"
}

# module "alb_target_group_alarms" {
#   enabled                        = "${var.alb_target_group_alarms_enabled}"
#   source                         = "git::https://github.com/cloudposse/terraform-aws-alb-target-group-cloudwatch-sns-alarms.git?ref=tags/0.5.0"
#   name                           = "${var.name}"
#   namespace                      = "${var.namespace}"
#   stage                          = "${var.stage}"
#   alarm_actions                  = ["${var.alb_target_group_alarms_alarm_actions}"]
#   ok_actions                     = ["${var.alb_target_group_alarms_ok_actions}"]
#   insufficient_data_actions      = ["${var.alb_target_group_alarms_insufficient_data_actions}"]
#   alb_name                       = "${var.alb_name}"
#   alb_arn_suffix                 = "${var.alb_arn_suffix}"
#   target_group_name              = "${module.alb_ingress.target_group_name}"
#   target_group_arn_suffix        = "${module.alb_ingress.target_group_arn_suffix}"
#   target_3xx_count_threshold     = "${var.alb_target_group_alarms_3xx_threshold}"
#   target_4xx_count_threshold     = "${var.alb_target_group_alarms_4xx_threshold}"
#   target_5xx_count_threshold     = "${var.alb_target_group_alarms_5xx_threshold}"
#   target_response_time_threshold = "${var.alb_target_group_alarms_response_time_threshold}"
#   period                         = "${var.alb_target_group_alarms_period}"
#   evaluation_periods             = "${var.alb_target_group_alarms_evaluation_periods}"
# }

