module "vpc" {
  source = "../../../../../modules/networking/terraform-aws-vpc"

  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  cidr_block = "${var.cidr_block}"
}
