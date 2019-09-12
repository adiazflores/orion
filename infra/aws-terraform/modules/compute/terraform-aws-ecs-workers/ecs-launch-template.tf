data "template_file" "userdata" {
  template = "${file("${path.module}/userdata.tpl")}"

  vars {
    ecs_cluster_name = "${var.ecs_cluster_name}"
  }
}

resource "aws_launch_template" "ecs_workers" {
  name                   = "${module.ec2_label.id}"
  instance_type          = "${var.ecs_instance_type}"
  ebs_optimized          = true
  image_id               = "${data.aws_ami.ecs_ami.id}"
  tags                   = "${module.ec2_label.tags}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  key_name               = "${var.key_name}"
  user_data              = "${base64encode(join("", data.template_file.userdata.*.rendered))}"

  iam_instance_profile {
    name = "${aws_iam_instance_profile.ecs_worker_instance_policy.name}"
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "volume"
    tags          = "${module.ec2_label.tags}"
  }

  tag_specifications {
    resource_type = "instance"
    tags          = "${module.ec2_label.tags}"
  }
}

resource "aws_autoscaling_group" "ecs_workers" {
  name     = "${module.ec2_label.id}"
  max_size = 10
  min_size = 3

  launch_template = {
    id      = "${aws_launch_template.ecs_workers.id}"
    version = "$$Latest"
  }

  vpc_zone_identifier  = ["${var.subnet_ids}"]
  termination_policies = ["NewestInstance"]

  enabled_metrics = [
    "GroupStandbyInstances",
    "GroupTotalInstances",
    "GroupPendingInstances",
    "GroupTerminatingInstances",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupMinSize",
    "GroupMaxSize",
  ]
}

resource "aws_autoscaling_policy" "ecs_scaling" {
  name = "${module.ec2_label.id}"

  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = "${aws_autoscaling_group.ecs_workers.id}"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    customized_metric_specification {
      metric_dimension {
        name  = "AutoScalingGroupName"
        value = "${module.ec2_label.id}"
      }

      namespace   = "Linux System"
      metric_name = "MemoryUtilization"
      statistic   = "Average"
    }

    target_value = "${var.target_tracking}"
  }
}
