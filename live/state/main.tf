terraform {
  required_version = "~> 0.13.0"

  required_providers {
    aws = {
      version = "~> 3.0"
      source  = "hashicorp/aws"
    }
  }

  backend "local" {
    path = "statefile/terraform.tfstate"
  }
}

provider "aws" {}

module "s3_backend" {
  source                         = "git@github.com:lievertz/terraform-demo.git//modules/backend?ref=v0.0.5"
  tf_state_aws_s3_bucket_name    = var.tf_state_aws_s3_bucket_name
  tf_state_aws_dynamo_table_name = var.tf_state_aws_dynamo_table_name
}
