variable "env" {
  description = "The environment of the group."
  type        = string
}

variable "assume_role_path" {
  description = "The relative file path to the assume role policy. This should be a json file containing the assume role policy."
  type        = string
}

variable "tf_state_aws_s3_bucket_name" {
  description = "The name of the s3 bucket for Terraform state."
  type        = string
}

variable "tf_state_aws_dynamo_table_name" {
  description = "The name of the Dynamo DB table for Terraform state locks."
  type        = string
}
