terraform {
  required_version = "~> 0.13.0"

  backend "local" {
    path = "statefile/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "s3_backend" {
  source                         = "git@github.com:lievertz/terraform-demo.git/modules/backend?ref=v0.0.1"
  tf_state_aws_s3_bucket_name    = var.tf_state_aws_s3_bucket_name
  tf_state_aws_dynamo_table_name = var.tf_state_aws_dynamo_table_name
}
