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

locals {
  admin_name = "${env}_admin"
  terraform_read_write_name = "${env}_tf_rw"
  terraform_read_only_name = "${env}_tf_r"
}

module "users" {
  source                         = "git@github.com:lievertz/terraform-demo.git//modules/iam/uesr?ref=v0.0.8"
  for_each   = var.user_group_map
  depends_on = [
    module.admin_group,
    module.terraform_read_write_group,
    module.terraform_read_only_group
  ]

  user_name        = each.key
  user_groups_list = each.value
  env              = var.env
}

module "admin_group" {
  source                         = "git@github.com:lievertz/terraform-demo.git//modules/iam/group?ref=v0.0.8"
  group_name    = local.admin_name
}

module "admin_role" {
  source                         = "git@github.com:lievertz/terraform-demo.git//modules/iam/role?ref=v0.0.8"
  role_name    = local.admin_name
  assume_role_file_path = var.assume_role_path
  iam_policy_document = file("admin_policy.json")
  env = var.env
}

module "terraform_read_write_group" {
  source                         = "git@github.com:lievertz/terraform-demo.git//modules/iam/group?ref=v0.0.8"
  group_name    = local.terraform_read_write_name
}

module "terraform_read_write_role" {
  source                         = "git@github.com:lievertz/terraform-demo.git//modules/iam/role?ref=v0.0.8"
  role_name    = local.terraform_read_write_name
  assume_role_file_path = var.assume_role_path
  iam_policy_document = templatefile("tf_rw_policy.json", {
    s3_bucket_name: var.tf_state_aws_s3_bucket_name,
    dynamo_table_name: var.tf_state_aws_dynamo_table_name
  })
  env = var.env
}

module "terraform_read_only_group" {
  source                         = "git@github.com:lievertz/terraform-demo.git//modules/iam/group?ref=v0.0.8"
  group_name    = local.terraform_read_only_name
}

module "terraform_read_only_role" {
  source                         = "git@github.com:lievertz/terraform-demo.git//modules/iam/role?ref=v0.0.8"
  role_name    = local.terraform_read_only_name
  assume_role_file_path = local.assume_role_path
  iam_policy_document = templatefile("tf_r_policy.json", {
    s3_bucket_name: var.tf_state_aws_s3_bucket_name
  })
  env = var.env
}
