#-----------------------------------
#    Naming
#-----------------------------------
variable "namespace" {
  description = "Namespace (e.g. `or` or `orion`)"
  type        = "string"
}

variable "stage" {
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  type        = "string"
}

variable "name" {
  description = "Name  (e.g. `app` or `cluster`)"
  type        = "string"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

#-----------------------------------
#    ECS Instance 
#-----------------------------------
variable "ecs_instance_type" {
  type        = "string"
  default     = "t3.medium"
  description = "Type of EC2 to use for the ECS cluster"
}

variable "vpc_security_group_ids" {
  type        = "string"
  description = "Security group ID for the ECS instances"
}

variable "key_name" {
  type        = "string"
  default     = ""
  description = "Pem key to use for the ecs instances"
}

variable "subnet_ids" {
  type        = "list"
  description = "Subnet IDS to build the auto scaling group in"
}

variable "target_tracking" {
  type        = "string"
  default     = "50"
  description = "Value of the target to scale with"
}

#-----------------------------------
#    ECS Cluster Information
#-----------------------------------
variable "ecs_cluster_name" {
  type        = "string"
  description = "Name of ECS Cluster to connect to"
}
