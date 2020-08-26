output "use_tags" {
  description = "Use these tags"
  value = merge(
    var.custom_tags,
    map(
      "env", var.env,
      "los", var.los,
      "service", var.service,
      "name", var.name
    )
  )
}
