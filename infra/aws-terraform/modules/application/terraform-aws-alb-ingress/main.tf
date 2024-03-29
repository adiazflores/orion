locals {
  create_target_group = "${var.target_group_arn == "" ? "true" : "false"}"
}

locals {
  target_group_arn = "${local.create_target_group == "true" ? aws_lb_target_group.default.arn : var.target_group_arn}"
}

data "aws_lb_target_group" "default" {
  arn = "${local.target_group_arn}"
}

module "default_label" {
  enabled    = "${local.create_target_group}"
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=tags/0.1.3"
  attributes = "${var.attributes}"
  delimiter  = "${var.delimiter}"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  tags       = "${var.tags}"
}

resource "aws_lb_target_group" "default" {
  count       = "${local.create_target_group == "true" ? 1 : 0}"
  name        = "${module.default_label.id}"
  port        = "${var.port}"
  protocol    = "${var.protocol}"
  vpc_id      = "${var.vpc_id}"
  target_type = "${var.target_type}"

  deregistration_delay = "${var.deregistration_delay}"

  health_check {
    path                = "${var.health_check_path}"
    timeout             = "${var.health_check_timeout}"
    healthy_threshold   = "${var.health_check_healthy_threshold}"
    unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
    interval            = "${var.health_check_interval}"
    matcher             = "${var.health_check_matcher}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "http_path" {
  count        = "${length(var.paths) > 0 && length(var.hosts) == 0 ? var.listener_arns_count : 0}"
  listener_arn = "${var.http_listener_arn}"
  priority     = "150"

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    field  = "path-pattern"
    values = ["${var.paths}"]
  }
}

resource "aws_lb_listener_rule" "https_path" {
  count        = "${length(var.paths) > 0 && length(var.hosts) == 0 ? var.listener_arns_count : 0}"
  listener_arn = "${var.https_listener_arn}"
  priority     = "${var.priority + count.index}"

  action {
    type             = "forward"
    target_group_arn = "${local.target_group_arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["${var.paths}"]
  }
}

resource "aws_lb_listener_rule" "hosts" {
  count        = "${length(var.hosts) > 0 && length(var.paths) == 0 ? var.listener_arns_count : 0}"
  listener_arn = "${var.listener_arns[count.index]}"
  priority     = "${var.priority + count.index}"

  action {
    type             = "forward"
    target_group_arn = "${local.target_group_arn}"
  }

  condition {
    field  = "host-header"
    values = ["${var.hosts}"]
  }
}

resource "aws_lb_listener_rule" "hosts_paths" {
  count        = "${length(var.paths) > 0 && length(var.hosts) > 0 ? var.listener_arns_count : 0}"
  listener_arn = "${var.listener_arns[count.index]}"
  priority     = "${var.priority + count.index}"

  action {
    type             = "forward"
    target_group_arn = "${local.target_group_arn}"
  }

  condition {
    field  = "host-header"
    values = ["${var.hosts}"]
  }

  condition {
    field  = "path-pattern"
    values = ["${var.paths}"]
  }
}
