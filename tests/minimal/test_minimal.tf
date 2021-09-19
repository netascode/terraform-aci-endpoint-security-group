terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "netascode/aci"
      version = ">=0.2.0"
    }
  }
}

resource "aci_rest" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

resource "aci_rest" "fvAp" {
  dn         = "${aci_rest.fvTenant.id}/ap-AP1"
  class_name = "fvAp"
}

module "main" {
  source = "../.."

  tenant              = aci_rest.fvTenant.content.name
  application_profile = aci_rest.fvAp.content.name
  name                = "ESG1"
  vrf                 = "VRF1"
}

data "aci_rest" "fvESg" {
  dn = "${aci_rest.fvAp.id}/esg-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fvESg" {
  component = "fvESg"

  equal "name" {
    description = "name"
    got         = data.aci_rest.fvESg.content.name
    want        = module.main.name
  }
}

data "aci_rest" "fvRsScope" {
  dn = "${data.aci_rest.fvESg.id}/rsscope"

  depends_on = [module.main]
}

resource "test_assertions" "fvRsScope" {
  component = "fvRsScope"

  equal "tnFvCtxName" {
    description = "tnFvCtxName"
    got         = data.aci_rest.fvRsScope.content.tnFvCtxName
    want        = "VRF1"
  }
}