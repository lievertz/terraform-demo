variable "env" {
  description = "The environment of tagged resource."
  type        = string
}

variable "los" {
  description = "Level of service of tagged resource: critical, live, batch, management."
  type        = string
}

variable "service" {
  description = "The name of the service of the tagged resource."
  type        = string
}

variable "name" {
  description = "The name of the tagged resource."
  type        = string
}

variable "custom_tags" {
  description = "Put in custom tags here as a map."
  type        = map
  default     = {}
}
