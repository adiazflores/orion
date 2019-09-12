#-----------------------------------
#    Naming
#-----------------------------------
name = "ecs"

namespace = "or"

stage = "staging"

#-----------------------------------
#    ECS Instance 
#-----------------------------------
ecs_instance_type = "t3.medium"

target_tracking = "45"

#-----------------------------------
#    Bastion
#-----------------------------------
key_name = "or-staging"

#-----------------------------------
#    Access Whitelist
#-----------------------------------
allowed_cidr_blocks = [
  "47.155.228.15/32",
  "73.158.75.227/32",
  "172.117.243.138/32",
  "10.100.0.0/22",                  # dev vpn
  "10.220.0.0/22",                  # staging vpn
  "10.240.0.0/22"                   # proto vpn
] #Ryan's Office, Arnie's SF Office, Arnie's LA Office, VPN Clients

#-----------------------------------
#   Route 53
#-----------------------------------
# from aws console: learnwithorion.com.
route53_zone = "Z3K9AOABEDRTO"

