#-----------------------------------
#    Naming
#-----------------------------------
# variable "name" {
#   type        = "string"
#   description = "Name (unique identifier for app or service)"
# }

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

variable "region" {
  type    = "string"
  default = "us-west-2"
}

variable "dns_zone_name" {
  type        = "string"
  description = "the dns zone to use"
}

variable "route53_zone" {
  type        = "string"
  description = "Hosted Zone Id in Route 53"
}
