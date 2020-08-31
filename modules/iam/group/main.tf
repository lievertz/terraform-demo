terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      version = ">= 3.0"
      source  = "hashicorp/aws"
    }
  }
}

resource "aws_iam_group" "group" {
  name = var.group_name
  path = var.group_path
}

resource "aws_iam_policy" "group_sts_policy" {
  description = "The ${var.group_name} group's IAM policy."
  name        = "${var.group_name}_sts_policy"
  path        = var.group_sts_policy_path
  policy      = file("${var.folder_path}/${var.group_name}_sts_policy.json")
}

resource "aws_iam_group_policy_attachment" "group_sts_policy_attachment" {
  group      = aws_iam_group.group.name
  policy_arn = aws_iam_policy.group_sts_policy.arn
}
