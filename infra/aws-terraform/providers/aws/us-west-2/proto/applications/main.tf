terraform {
  backend "s3" {
    bucket = "orion-terraform"
    key    = "proto/applications/terraform.tfstate"
    region = "us-west-2"
  }
}

provider "aws" {
  region = "us-west-2"
}

#-----------------------------------
#    Lookup Networking Information
#-----------------------------------
data "terraform_remote_state" "network" {
  backend = "s3"

  config {
    bucket = "orion-terraform"
    key    = "${var.stage}/networking/terraform.tfstate"
    region = "us-west-2"
  }
}

#-----------------------------------
#    Lookup Compute Information
#-----------------------------------
data "terraform_remote_state" "compute" {
  backend = "s3"

  config {
    bucket = "orion-terraform"
    key    = "${var.stage}/compute/terraform.tfstate"
    region = "us-west-2"
  }
}

#-----------------------------------
#    ECS Web App
#-----------------------------------
# module "ecs-web-app" {
#   source = "../../../../../modules/application/terraform-aws-ecs-web-app"
#   name   = "helloworld"
# }

