# vpn client admin guide https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/what-is.html

# create self signed certs for authentication https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/authentication-authrization.html

module "vpn" {
  source = "../../../../../modules/networking/terraform-aws-client-vpn"

  subnet_id       = "${module.app_subnets.private_subnet_ids[1]}"
  vpn_dns         = "${var.vpn_dns}"
  stage           = "${var.stage}"
  vpn_client_cidr = "${var.vpn_client_cidr}"
  vpn_server_arn  = "${var.vpn_server_arn}"
  vpn_client_arn  = "${var.vpn_client_arn}"
}

# There are still additional things you need to do to make this work because TF doesnt have all the neccesary resources
#
# https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/cvpn-working-rules.html#cvpn-working-rule-authorize
# add both local network cidr as well as 0.0.0.0/0 for internet traffic
#
# you also need to update the config file to have the client cert and client key

# manual POST steps until AWS/hasicorp improves the terraform module:
# after the VPN Endpoint has been created you need to
# 1a. go to VPC > Clinet VPN Endpoints > choose your endpoint ID
# 1b. on route table, add a default route 0.0.0.0/0 to allow internet access
# 2a. on authorizations route table tab, add route for internet (0.0.0.0/0)
# 2b. on authorizations route table tab, add route for vpc (10.X.0.0/16)
# 3a. download the client configuration (button on the top) , then edit it to add the
# 3b. add a <cert> </cert> block and inside add the client certificate block
# 3c. add a <key> </key> block and inside add the client private key block
