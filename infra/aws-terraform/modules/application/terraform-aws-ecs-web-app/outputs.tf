output "scale_down_policy_arn" {
  description = "Autoscaling scale up policy ARN"
  value       = "${module.autoscaling.scale_down_policy_arn}"
}

output "scale_up_policy_arn" {
  description = "Autoscaling scale up policy ARN"
  value       = "${module.autoscaling.scale_up_policy_arn}"
}

output "service_name" {
  description = "ECS Service Name"
  value       = "${module.ecs_alb_service_task.service_name}"
}

output "task_role_arn" {
  description = "ECS Task role ARN"
  value       = "${module.ecs_alb_service_task.task_role_arn}"
}

output "service_security_group_id" {
  description = "Security Group id of the ECS task"
  value       = "${module.ecs_alb_service_task.service_security_group_id}"
}

output "repository_name" {
  description = "Name of the ECR repository"
  value       = "${module.ecr.repository_name}"
}

output "registry_url" {
  description = "Url of ECR Registry"
  value       = "${module.ecr.registry_url}"
}
