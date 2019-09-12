locals {
  public_cidr_block = "${cidrsubnet(module.vpc.vpc_cidr_block, 5, 0)}"
  app_cidr_block    = "${cidrsubnet(module.vpc.vpc_cidr_block, 5, 4)}"
  db_cidr_block     = "${cidrsubnet(module.vpc.vpc_cidr_block, 5, 8)}"
}

module "public_subnets" {
  source              = "../../../../../modules/networking/terraform-aws-multi-az-subnets"
  name                = ""
  namespace           = "${var.namespace}"
  stage               = "${var.stage}"
  vpc_id              = "${module.vpc.vpc_id}"
  availability_zones  = "${var.availability_zones}"
  type                = "public"
  igw_id              = "${module.vpc.igw_id}"
  nat_gateway_enabled = "true"
  cidr_block          = "${local.public_cidr_block}"
}

module "app_subnets" {
  source             = "../../../../../modules/networking/terraform-aws-multi-az-subnets"
  name               = "app"
  namespace          = "${var.namespace}"
  stage              = "${var.stage}"
  vpc_id             = "${module.vpc.vpc_id}"
  availability_zones = "${var.availability_zones}"
  type               = "private"
  cidr_block         = "${local.app_cidr_block}"
  az_ngw_ids         = "${module.public_subnets.az_ngw_ids}"
  az_ngw_count       = "3"
}

module "db_subnets" {
  source             = "../../../../../modules/networking/terraform-aws-multi-az-subnets"
  name               = "db"
  namespace          = "${var.namespace}"
  stage              = "${var.stage}"
  vpc_id             = "${module.vpc.vpc_id}"
  availability_zones = "${var.availability_zones}"
  type               = "private"
  cidr_block         = "${local.db_cidr_block}"
  az_ngw_ids         = "${module.public_subnets.az_ngw_ids}"
  az_ngw_count       = "3"
}
