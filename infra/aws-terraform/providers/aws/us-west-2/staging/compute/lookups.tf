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
