#-----------------------------------
#    ECS Worker Instance Policy
#-----------------------------------
data "aws_iam_policy_document" "ecs_worker_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ecs_worker_role" {
  name               = "${module.ec2_label.id}"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_worker_assume_role.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_worker_service_role" {
  role       = "${aws_iam_role.ecs_worker_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_worker_session_manager" {
  role       = "${aws_iam_role.ecs_worker_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "ecs_worker_instance_policy" {
  name = "${aws_iam_role.ecs_worker_role.name}"
  role = "${aws_iam_role.ecs_worker_role.name}"
}

#-----------------------------------
#    ECS Service Policy
#-----------------------------------

data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ecs_service_role" {
  name               = "${module.ecs_label.id}"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_assume_role.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_service_role" {
  role       = "${aws_iam_role.ecs_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}
