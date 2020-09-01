variable "tf_state_aws_s3_bucket_name" {
  description = "The name of the AWS S3 Bucket for storing TF state"
  type        = string
}

variable "tf_state_aws_dynamo_table_name" {
  description = "The name of the AWS Dynamo Table for locking TF state"
  type        = string
}

variable "env" {
  description = "The environment of the group."
  type        = string
}
