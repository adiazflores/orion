module "ui" {
  source                 = "../../../../../modules/application/terraform-aws-ecs-web-app"
  namespace              = "${var.namespace}"
  stage                  = "${var.stage}"
  name                   = "ui"
  aws_logs_region        = "us-west-2"
  vpc_id                 = "${data.terraform_remote_state.network.vpc_id}"
  zone_id                = "${var.route53_zone}"
  dns_name               = "ui-proto.learnwithorion.com"
  certificate_arn        = "arn:aws:acm:us-west-2:166954342823:certificate/e5724928-e1f3-4c92-a710-17a0e3fc434e"
  codepipeline_enabled   = "false"
  ecs_cluster_arn        = "${data.terraform_remote_state.compute.ecs_cluster_arn}"
  ecs_cluster_name       = "${data.terraform_remote_state.compute.ecs_cluster_name}"
  ecs_private_subnet_ids = ["${data.terraform_remote_state.network.app_subnets}"]
  alb_subnet_ids         = ["${data.terraform_remote_state.network.public_subnets}"]
  container_cpu          = "512"
  container_memory       = "2048"
  container_port         = "80"

  port_mappings = [
    {
      containerPort = "80"
      hostPort      = "80"
      protocol      = "tcp"
    },
  ]

  desired_count            = "1"
  autoscaling_enabled      = "true"
  autoscaling_dimension    = "cpu"
  autoscaling_min_capacity = 1
  autoscaling_max_capacity = 5

  launch_type                                     = "FARGATE"
  alb_ingress_healthcheck_path                    = "/ping"
  alb_ingress_paths                               = ["/*"]
  alb_ingress_listener_priority                   = "100"
  ecs_alarms_enabled                              = "true"
  alb_target_group_alarms_enabled                 = "true"
  alb_target_group_alarms_3xx_threshold           = "25"
  alb_target_group_alarms_4xx_threshold           = "25"
  alb_target_group_alarms_5xx_threshold           = "25"
  alb_target_group_alarms_response_time_threshold = "0.5"
  alb_target_group_alarms_period                  = "300"
  alb_target_group_alarms_evaluation_periods      = "1"

  environment = [
    {
      name  = "AWS_ENV_PATH"
      value = "/${var.stage}/ui/"
    },
    {
      name  = "AWS_REGION"
      value = "${var.region}"
    },
  ]
}
