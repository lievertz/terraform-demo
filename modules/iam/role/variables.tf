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

variable "policy_folder_path" {
  description = "The relative file path to the folder where the role IAM policy is located. Policies within should be named <role_name>_policy.json"
  type        = string
  default     = "."
}

variable "assume_role_file_path" {
  description = "The relative file path to the assume role policy. This should be a json file containing the assume role policy."
  type        = string
  default     = "."
}
