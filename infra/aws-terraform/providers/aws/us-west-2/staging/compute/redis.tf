resource "random_string" "auth_token" {
  length  = 64
  special = false
}

module "redis" {
  source                       = "../../../../../modules/compute/terraform-aws-elasticache-redis"
  namespace                    = "${var.namespace}"
  stage                        = "${var.stage}"
  name                         = "redis-stg"
  zone_id                      = "${var.route53_zone}"
  vpc_id                       = "${data.terraform_remote_state.network.vpc_id}"
  subnets                      = "${data.terraform_remote_state.network.db_subnets}"
  access_cidr_blocks           = ["${data.terraform_remote_state.network.vpc_cidr}", "${data.terraform_remote_state.network.vpn_client_cidr}"]
  maintenance_window           = "wed:03:00-wed:04:00"
  cluster_size                 = "1"
  instance_type                = "cache.t2.micro"
  apply_immediately            = "true"
  availability_zones           = ["us-west-2a", "us-west-2b", "us-west-2c"]
  automatic_failover           = "false"
  transit_encryption_enabled   = "false"
  auth_token                   = "${random_string.auth_token.result}"
  engine_version               = "4.0.10"
  family                       = "redis4.0"
  port                         = "6379"
  alarm_cpu_threshold_percent  = "75"
  alarm_memory_threshold_bytes = "10000000"
  at_rest_encryption_enabled   = "true"

  #   parameter = [
  #     {

  #     },
  #   ]
}
