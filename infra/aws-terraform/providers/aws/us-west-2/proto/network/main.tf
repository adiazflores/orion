terraform {
  backend "s3" {
    bucket = "orion-terraform"
    key    = "proto/networking/terraform.tfstate"
    region = "us-west-2"
  }
}

provider "aws" {
  region = "us-west-2"
}
