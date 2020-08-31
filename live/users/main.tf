terraform {
  required_version = "~> 0.13.0"

  required_providers {
    aws = {
      version = "~> 3.0"
      source  = "hashicorp/aws"
    }
  }

  backend "s3" {
    key = "users/terraform.tfstate"
    bucket = "lievertz-terraform-demo-state-bucket"
    dynamodb_table = "lievertz-terraform-demo-state-locks"
  }
}

provider "aws" {}

locals {
  admin_name = "lievertz_admin"
  terraform_read_write_name = "lievertz_tf_rw"
  terraform_read_only_name = "lievertz_tf_r"
  assume_role_path = "./standard_assume_role_policy.json"
}

module "admin_group" {
  source                         = "git@github.com:lievertz/terraform-demo.git//modules/iam/group?ref=v0.0.6"
  group_name    = local.admin_name
}

module "admin_role" {
  source                         = "git@github.com:lievertz/terraform-demo.git//modules/iam/role?ref=v0.0.6"
  role_name    = local.admin_name
  assume_role_file_path = local.assume_role_path
  env = var.env
}

module "terraform_read_write_group" {
  source                         = "git@github.com:lievertz/terraform-demo.git//modules/iam/group?ref=v0.0.6"
  group_name    = local.terraform_read_write_name
}

module "terraform_read_write_role" {
  source                         = "git@github.com:lievertz/terraform-demo.git//modules/iam/role?ref=v0.0.6"
  role_name    = local.terraform_read_write_name
  assume_role_file_path = local.assume_role_path
  env = var.env
}

module "terraform_read_only_group" {
  source                         = "git@github.com:lievertz/terraform-demo.git//modules/iam/group?ref=v0.0.6"
  group_name    = local.terraform_read_only_name
}

module "terraform_read_only_role" {
  source                         = "git@github.com:lievertz/terraform-demo.git//modules/iam/role?ref=v0.0.6"
  role_name    = local.terraform_read_only_name
  assume_role_file_path = local.assume_role_path
  env = var.env
}
