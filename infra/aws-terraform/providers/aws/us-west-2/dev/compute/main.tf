terraform {
  backend "s3" {
    bucket = "orion-terraform"
    key    = "dev/compute/terraform.tfstate"
    region = "us-west-2"
  }
}

provider "aws" {
  region = "us-west-2"
}
