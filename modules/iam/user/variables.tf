variable "user_name" {
  description = "The name of the user."
  type        = string
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
