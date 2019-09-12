#-----------------------------------
#    Naming
#-----------------------------------
name = "vpc"

namespace = "or"

stage = "proto"

#-----------------------------------
#    Networking
#-----------------------------------
cidr_block = "10.40.0.0/16"
vpn_dns = "10.40.0.2"
vpn_client_cidr = "10.240.0.0/22"
vpn_server_arn = "arn:aws:acm:us-west-2:166954342823:certificate/3ed8818d-44c7-4036-96aa-ecce5bab2961"
vpn_client_arn = "arn:aws:acm:us-west-2:166954342823:certificate/460c69ae-f0c8-4d21-9712-2a2d405bb2e2"

