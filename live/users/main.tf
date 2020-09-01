terraform {
  required_version = "~> 0.13.0"

  required_providers {
    aws = {
      version = "~> 3.0"
      source  = "hashicorp/aws"
    }
  }

  backend "s3" {
    key            = "users/terraform.tfstate"
    bucket         = "lievertz-terraform-demo-state-bucket"
    dynamodb_table = "lievertz-terraform-demo-state-locks"
  }
}

provider "aws" {}

locals {
  users_groups = {
    mlievertz = [
      "${var.env}_admin",
      "${var.env}_tf_rw"
    ],
    gsmith = [
      "${var.env}_tf_rw"
    ],
    pmanning = [
      "${var.env}_tf_r"
    ]
  }
}

module "users_and_permissions" {
  source                         = "git@github.com:lievertz/terraform-demo.git//modules/iam/users_and_permissions?ref=v0.0.12"
  env                            = var.env
  assume_role_path               = "./standard_assume_role_policy.json"
  user_group_map                 = local.users_groups
  tf_state_aws_s3_bucket_name    = var.tf_state_aws_s3_bucket_name
  tf_state_aws_dynamo_table_name = var.tf_state_aws_dynamo_table_name
}
