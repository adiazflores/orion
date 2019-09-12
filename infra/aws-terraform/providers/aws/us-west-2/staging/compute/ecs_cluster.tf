module "label" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.3"
  namespace = "${var.namespace}"
  name      = "${var.name}"
  stage     = "${var.stage}"
  delimiter = "${var.delimiter}"
}

#-----------------------------------
#    Create ECS Cluster
#-----------------------------------
module "ecs_cluster" {
  source    = "../../../../../modules/compute/terraform-aws-ecs-cluster"
  name      = "${var.name}"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
}

#-----------------------------------
#  Create ECS Worker Security Group
# #-----------------------------------
# resource "aws_security_group" "ecs_security_group" {
#   name        = "${module.label.id}"
#   description = "Security group for ECS in ${var.stage}"
#   vpc_id      = "${data.terraform_remote_state.network.vpc_id}"
# }


# resource "aws_security_group_rule" "egress" {
#   type        = "egress"
#   from_port   = 0
#   to_port     = 65535
#   protocol    = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]


#   security_group_id = "${aws_security_group.ecs_security_group.id}"
# }


#-----------------------------------
#    Create ECS Worker Nodes
#-----------------------------------
# module "ecs_workers" {
#   source = "../../../../../modules/compute/terraform-aws-ecs-workers"


#   name                   = "${var.name}"
#   namespace              = "${var.namespace}"
#   stage                  = "${var.stage}"
#   ecs_instance_type      = "${var.ecs_instance_type}"
#   vpc_security_group_ids = "${aws_security_group.ecs_security_group.id}"
#   subnet_ids             = "${data.terraform_remote_state.network.app_subnets}"
#   ecs_cluster_name       = "${module.ecs_cluster.cluster_name}"
#   target_tracking        = "${var.target_tracking}"
# }

