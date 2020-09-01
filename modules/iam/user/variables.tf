variable "user_name" {
  description = "The name of the user."
  type        = string
}

variable "user_groups_list" {
  description = "A list of group names the user should be a member of."
  type = list(string)
}

variable "user_path" {
  description = "The IAM path of the user."
  type        = string
  default     = "/default/"
}

variable "env" {
  description = "The env of the user."
  type        = string
}
