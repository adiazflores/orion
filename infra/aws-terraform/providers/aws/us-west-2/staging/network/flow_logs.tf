module "vpc_flow_logs" {
  source = "../../../../../modules/networking/terraform-aws-vpc-flowlogs"

  name              = "${var.name}"
  namespace         = "${var.namespace}"
  stage             = "${var.stage}"
  retention_in_days = "14"
  vpc_id            = "${module.vpc.vpc_id}"
}
