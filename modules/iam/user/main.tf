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
  name    = var.user_name
}

resource "aws_iam_user" "user" {
  name = var.user_name
  path = var.user_path
  # Users will use UI to manage creds, but we want to manage create/destroy in Terraform
  force_destroy = true

  tags = module.tags.use_tags
}
