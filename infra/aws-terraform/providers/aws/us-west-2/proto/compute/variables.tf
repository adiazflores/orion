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
#    ECS Instance
#-----------------------------------
variable "ecs_instance_type" {
  type        = "string"
  default     = "t3.medium"
  description = "Type of EC2 to use for the ECS cluster"
}

variable "target_tracking" {
  type        = "string"
  default     = "50"
  description = "Value of the target to scale with"
}

#-----------------------------------
#    Bastion
#-----------------------------------

variable "key_name" {
  type        = "string"
  description = "Key pair name generated in AWS to allow access to Bastion"
}

#-----------------------------------
#    Access Whitelist
#-----------------------------------

variable "allowed_cidr_blocks" {
  type        = "list"
  default     = ["0.0.0.0/0"]
  description = "Which IPS are allowed to access the bastion"
}

#-----------------------------------
#   Route 53
#-----------------------------------
variable "route53_zone" {
  type        = "string"
  description = "Hosted Zone Id in Route 53"
}

variable "dns_zone_name" {
  type        = "string"
  description = "the dns zone to use"
}
