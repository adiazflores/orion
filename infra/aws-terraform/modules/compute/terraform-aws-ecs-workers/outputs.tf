output "ecs_ami" {
  value = "${data.aws_ami.ecs_ami.name}"
}
