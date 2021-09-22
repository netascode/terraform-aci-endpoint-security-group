output "dn" {
  value       = aci_rest.fvESg.id
  description = "Distinguished name of `fvESg` object."
}

output "name" {
  value       = aci_rest.fvESg.content.name
  description = "Endpoint security group name."
}

output "tenant" {
  value       = regex("uni\\/tn-(.*)\\/ap.*", aci_rest.fvESg.dn)[0]
  description = "Tenant name."
}

output "application_profile" {
  value       = regex(".*\\/ap-(.*)\\/.*", aci_rest.fvESg.dn)[0]
  description = "Application profile name."
}

output "vrf" {
  value       = aci_rest.fvRsScope.content.tnFvCtxName
  description = "VRF name."
}