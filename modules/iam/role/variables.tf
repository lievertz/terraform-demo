variable "env" {
  description = "The environment of the group."
  type        = string
}

variable "role_name" {
  description = "The name of the role."
  type        = string
}

variable "role_path" {
  description = "The IAM path of the role."
  type        = string
  default     = "/default/"
}

variable "role_policy_path" {
  description = "The IAM path of the role policy."
  type        = string
  default     = "/default/"
}

variable "iam_policy_document" {
  description = "The text of an IAM policy document describing IAM policy this role should have."
  type        = string
}

variable "assume_role_file_path" {
  description = "The relative file path to the assume role policy. This should be a json file containing the assume role policy."
  type        = string
}
