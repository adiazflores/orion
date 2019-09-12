#-----------------------------------
#    Naming
#-----------------------------------
variable "name" {
  type        = "string"
  description = "Name (unique identifier for app or service)"
}

variable "namespace" {
  type        = "string"
  description = "Namespace"
}

variable "delimiter" {
  type        = "string"
  description = "The delimiter to be used in labels."
  default     = "-"
}

variable "stage" {
  type        = "string"
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

#-----------------------------------
#    Networking
#-----------------------------------

variable "cidr_block" {
  type        = "string"
  description = "Cidr block of the VPC"
}

variable "availability_zones" {
  type        = "list"
  description = "Availability zones to use"
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "vpn_client_cidr" {
  type        = "string"
  description = "CIDR Block for VPN Clients"
  default     = "10.100.0.0/22"
}

variable "vpn_dns" {
  type        = "string"
  description = "dns servers that will be given to vpn clients"
}

variable "vpn_server_arn" {
  type        = "string"
  description = "the server ARN for this stage's VPN"
}

variable "vpn_client_arn" {
  type        = "string"
  description = "the client ARN for this stage's VPN"
}
