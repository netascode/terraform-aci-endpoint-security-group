<!-- BEGIN_TF_DOCS -->
# Endpoint Security Group Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_endpoint_security_group" {
  source = "git::https://github.com/vaneuk/terraform-aci-endpoint-security-group.git?ref=v0.0.1"
  # source  = "netascode/aci-endpoint-security-group/aci"
  version = ">= 0.0.1"

  name                = "ESG1"
  tenant              = "ABC"
  application_profile = "AP1"
  vrf                 = "VRF1"
  contracts = {
    consumers = ["CON1"]
    providers = ["CON1"]
  }
  epg_selectors = [
    {
      tenant              = "ABC"
      application_profile = "AP1"
      endpoint_group      = "EPG1"
    }
  ]
  esg_contract_masters = [
    {
      tenant                  = "ABC"
      application_profile     = "AP1"
      endpoint_security_group = "ESG_MASTER"
    }
  ]
  ip_subnet_selectors = [
    {
      value = "1.1.1.0/24"
    },
    {
      key         = "ip"
      operator    = "equals"
      value       = "1.1.2.0/24"
      description = "foo"
    }
  ]
  tag_selectors = [
    {
      key      = "esg_name"
      operator = "contains"
      value    = "foo"
    },
    {
      key   = "esg_name"
      value = "bar"
    }
  ]
}

```
<!-- END_TF_DOCS -->