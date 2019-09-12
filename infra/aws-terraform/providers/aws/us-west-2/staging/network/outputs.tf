output "vpc_id" {
  value       = "${module.vpc.vpc_id}"
  description = "VPC ID "
}

output "public_subnets" {
  value       = "${module.public_subnets.public_subnet_ids}"
  description = "List of public subnet ids"
}

output "app_subnets" {
  value = "${module.app_subnets.private_subnet_ids}"
}

output "db_subnets" {
  value = "${module.db_subnets.private_subnet_ids}"
}

output "vpc_cidr" {
  value = "${module.vpc.vpc_cidr_block}"
}

output "vpn_client_cidr" {
  value = "${var.vpn_client_cidr}"
}
