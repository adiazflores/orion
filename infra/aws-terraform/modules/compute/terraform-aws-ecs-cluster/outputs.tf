output "cluster_arn" {
  value = "${aws_ecs_cluster.default.arn}"
}

output "cluster_id" {
  value = "${aws_ecs_cluster.default.id}"
}

output "cluster_name" {
  value = "${aws_ecs_cluster.default.name}"
}
