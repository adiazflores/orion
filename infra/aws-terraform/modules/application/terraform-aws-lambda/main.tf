resource "aws_lambda_function" "lambda" {
  filename         = "${var.zip_file_path}${var.name}.zip"
  function_name    = "${var.name}_lambda_${var.handler}"
  handler          = "${var.name}_lambda_${var.handler}.${var.handler}"
  role             = "${aws_iam_role.iam_role_for_lambda.arn}"
  runtime          = "${var.runtime}"
  source_code_hash = "${base64sha256(file("${var.zip_file_path}${var.name}.zip"))}"
}

resource "aws_iam_role" "iam_role_for_lambda" {
  name = "iam_role_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

output "name" {
  value = "${aws_lambda_function.lambda.function_name}"
}

output "arn" {
  value = "${aws_lambda_function.lambda.arn}"
}
