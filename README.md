<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-scaffolding/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-scaffolding/actions/workflows/test.yml)

# Terraform ACI Endpoint Security Group Module

Description

Location in GUI:
`Tenants` » `XXX` » `Application Profiles` » `XXX` » `Endpoint Security Groups`

## Examples

```hcl
module "aci_endpoint_security_group" {
  source  = "netascode/aci-endpoint-security-group/aci"
  version = ">= 0.0.1"

  name                = "ESG1"
  description         = "My Description"
  tenant              = aci_rest.fvTenant.content.name
  application_profile = aci_rest.fvAp.content.name
  vrf                 = "VRF1"
  shutdown            = false
  intra_esg_isolation = true
  preferred_group     = true
  contracts = {
    consumers = ["CON1"]
    providers = ["CON1"]
  }
  esg_contract_masters = [
    {
      tenant                  = "TF"
      application_profile     = "AP1"
      endpoint_security_group = "ESG_MASTER"
    }
  ]
  tag_selectors = [
    {
      key      = "key1"
      operator = "contains"
      value    = "value1"
    },
    {
      key      = "key2"
      operator = "equals"
      value    = "value2"
    },
    {
      key      = "key3"
      operator = "regex"
      value    = "value3"
    },
    {
      key   = "key4"
      value = "value4"
    }
  ]
  epg_selectors = [
    {
      tenant              = "TF"
      application_profile = "AP1"
      endpoint_group      = "EPG1"
    }
  ]
  ip_subnet_selectors = [
    {
      value = "1.1.1.0/24"
    },
    {
      key   = "ip"
      value = "1.1.2.0/24"
    },
    {
      key      = "ip"
      operator = "equals"
      value    = "1.1.3.0/24"
    },
    {
      value       = "1.1.4.0/24"
      description = "foo"
    }
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 0.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 0.2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Endpoint security group name. | `string` | n/a | yes |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Tenant name. | `string` | n/a | yes |
| <a name="input_application_profile"></a> [application\_profile](#input\_application\_profile) | Application profile name. | `string` | n/a | yes |
| <a name="input_vrf"></a> [vrf](#input\_vrf) | VRF name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_shutdown"></a> [shutdown](#input\_shutdown) | Shutdown. | `bool` | `false` | no |
| <a name="input_intra_esg_isolation"></a> [intra\_esg\_isolation](#input\_intra\_esg\_isolation) | Intra ESG isolation. | `bool` | `false` | no |
| <a name="input_preferred_group"></a> [preferred\_group](#input\_preferred\_group) | Preferred group membership. | `bool` | `false` | no |
| <a name="input_contracts"></a> [contracts](#input\_contracts) | Contracts. | <pre>object({<br>    consumers = optional(list(string))<br>    providers = optional(list(string))<br>  })</pre> | `{}` | no |
| <a name="input_esg_contract_masters"></a> [esg\_contract\_masters](#input\_esg\_contract\_masters) | List of ESG contract masters. | <pre>list(object({<br>    tenant                  = string<br>    application_profile     = string<br>    endpoint_security_group = string<br>  }))</pre> | `[]` | no |
| <a name="input_tag_selectors"></a> [tag\_selectors](#input\_tag\_selectors) | List of tag selectors.  Choices `operator`: `contains`, `equals`, `regex`. Default value `operator`: `equals`. Default value `description`: '' | <pre>list(object({<br>    key         = string<br>    operator    = optional(string)<br>    value       = string<br>    description = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_epg_selectors"></a> [epg\_selectors](#input\_epg\_selectors) | List of epg selectors. Format TBD | <pre>list(object({<br>    tenant              = string<br>    application_profile = string<br>    endpoint_group      = string<br>    description         = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_ip_subnet_selectors"></a> [ip\_subnet\_selectors](#input\_ip\_subnet\_selectors) | List of ip subnet selectors. Format TBD | <pre>list(object({<br>    key         = optional(string)<br>    operator    = optional(string)<br>    value       = string<br>    description = optional(string)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fvESg` object. |
| <a name="output_name"></a> [name](#output\_name) | Endpoint security group name. |
| <a name="output_tenant"></a> [tenant](#output\_tenant) | Tenant name. |
| <a name="output_application_profile"></a> [application\_profile](#output\_application\_profile) | Application profile name. |
| <a name="output_vrf"></a> [vrf](#output\_vrf) | VRF name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest.fvEPSelector](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.fvEPgSelector](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.fvESg](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.fvRsCons](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.fvRsProv](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.fvRsScope](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.fvRsSecInherited](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.fvTagSelector](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
<!-- END_TF_DOCS -->