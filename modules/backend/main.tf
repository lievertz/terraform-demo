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
  env     = "infra"
  los     = "management"
  service = "terraform"
  name    = "terraform state"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.tf_state_aws_s3_bucket_name

  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = module.tags.use_tags
}

resource "aws_dynamodb_table" "terraform_lock" {
  name         = var.tf_state_aws_dynamo_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = module.tags.use_tags
}
