terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      version = ">= 3.0"
      source  = "hashicorp/aws"
    }
  }
}

module "tags" {
  source  = "git@github.com:lievertz/terraform-demo.git//modules/tags?ref=v0.0.5"
  env     = var.env
  los     = "management"
  service = "permissions"
  name    = var.role_name
}

resource "aws_iam_role" "role" {
  name               = var.role_name
  path               = var.role_path
  assume_role_policy = file(var.assume_role_file_path)

  tags = module.tags.use_tags
}

resource "aws_iam_policy" "role_policy" {
  description = "The ${var.role_name} role's IAM policy."
  name        = "${var.role_name}_policy"
  path        = var.role_policy_path
  policy      = var.iam_policy_document
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  group      = aws_iam_role.role.name
  policy_arn = aws_iam_policy.role_policy.arn
}
