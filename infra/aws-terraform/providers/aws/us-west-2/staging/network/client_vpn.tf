#import cert with these steps https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/authentication-authrization.html#mutual

resource "aws_ec2_client_vpn_endpoint" "client_vpn" {
  description            = "client vpn"
  server_certificate_arn = "arn:aws:acm:us-west-2:166954342823:certificate/3ea04298-7521-4b2b-9b5b-966bff01a6e8"
  client_cidr_block      = "${var.vpn_client_cidr}"

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = "arn:aws:acm:us-west-2:166954342823:certificate/460c69ae-f0c8-4d21-9712-2a2d405bb2e2"
  }

  connection_log_options {
    enabled = false

    # cloudwatch_log_group = "${aws_cloudwatch_log_group.lg.name}"
    # cloudwatch_log_stream = "${aws_cloudwatch_log_stream.ls.name}"
  }
}

resource "aws_ec2_client_vpn_network_association" "client_vpn_connection" {
  client_vpn_endpoint_id = "${aws_ec2_client_vpn_endpoint.client_vpn.id}"
  subnet_id              = "${module.app_subnets.private_subnet_ids[1]}"
}
