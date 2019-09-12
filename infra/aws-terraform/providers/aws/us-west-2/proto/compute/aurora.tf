data "aws_ssm_parameter" "db_pw" {
  name = "/${var.stage}/postgresql/masterpass"
}

module "rds_cluster_aurora_mysql_serverless" {
  source              = "../../../../../modules/compute/terraform-aws-rds-cluster"
  namespace           = "${var.namespace}"
  stage               = "${var.stage}"
  name                = "db"
  engine              = "aurora-postgresql"
  engine_mode         = "provisioned"
  engine_version      = "10.5"
  cluster_family      = "aurora-postgresql10"
  cluster_size        = "2"
  admin_user          = "admin1"
  admin_password      = "${data.aws_ssm_parameter.db_pw.value}"
  db_name             = "postgres"
  db_port             = "5432"
  instance_type       = "db.r4.large"
  vpc_id              = "${data.terraform_remote_state.network.vpc_id}"
  subnets             = "${data.terraform_remote_state.network.db_subnets}"
  allowed_cidr_blocks = ["${data.terraform_remote_state.network.vpc_cidr}", "${data.terraform_remote_state.network.vpn_client_cidr}"]
}
