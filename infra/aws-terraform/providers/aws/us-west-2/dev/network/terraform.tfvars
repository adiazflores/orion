#-----------------------------------
#    Naming
#-----------------------------------
name = "vpc"

namespace = "or"

stage = "dev"

#-----------------------------------
#    Networking
#-----------------------------------
cidr_block = "10.10.0.0/16"
vpn_dns = "10.10.0.2"
vpn_client_cidr = "10.100.0.0/22"

vpn_server_arn = "arn:aws:acm:us-west-2:166954342823:certificate/d6e7d60d-531c-4033-81bb-caf394abbded"
vpn_client_arn = "arn:aws:acm:us-west-2:166954342823:certificate/1b570a20-10a6-4705-a2ef-908583c259f6"

