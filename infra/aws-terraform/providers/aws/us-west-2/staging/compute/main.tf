terraform {
  backend "s3" {
    bucket = "orion-terraform"
    key    = "staging/compute/terraform.tfstate"
    region = "us-west-2"
  }
}

provider "aws" {
  region = "us-west-2"
}
