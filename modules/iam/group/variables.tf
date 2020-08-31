variable "group_name" {
  description = "The name of the group."
  type        = string
}

variable "group_path" {
  description = "The IAM path of the group."
  type        = string
  default     = "/default/"
}

variable "group_sts_policy_path" {
  description = "The IAM path of the group STS policy."
  type        = string
  default     = "/default/"
}

variable "folder_path" {
  description = "The relative file path to where the group sts policy is located. This should be a json file containing a policy giving assume role permissions."
  type        = string
  default     = "."
}
