output "dn" {
  value       = aci_rest.fvESg.id
  description = "Distinguished name of `fvESg` object."
}

output "name" {
  value       = aci_rest.fvESg.content.name
  description = "Endpoint security group name."
}
