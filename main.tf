resource "aci_rest" "fvESg" {
  dn         = "uni/tn-${var.tenant}/ap-${var.application_profile}/esg-${var.name}"
  class_name = "fvESg"
  content = {
    name       = var.name
    descr      = var.description
    pcEnfPref  = var.intra_esg_isolation == true ? "enforced" : "unenforced"
    prefGrMemb = var.preferred_group == true ? "include" : "exclude"
    shutdown   = var.shutdown == true ? "yes" : "no"
  }
}

resource "aci_rest" "fvRsScope" {
  dn         = "${aci_rest.fvESg.dn}/rsscope"
  class_name = "fvRsScope"
  content = {
    tnFvCtxName = var.vrf
  }
}

resource "aci_rest" "fvRsCons" {
  for_each   = toset(var.contract_consumers)
  dn         = "${aci_rest.fvESg.dn}/rscons-${each.value}"
  class_name = "fvRsCons"
  content = {
    tnVzBrCPName = each.value
  }
}

resource "aci_rest" "fvRsProv" {
  for_each   = toset(var.contract_providers)
  dn         = "${aci_rest.fvESg.dn}/rsprov-${each.value}"
  class_name = "fvRsProv"
  content = {
    tnVzBrCPName = each.value
  }
}

resource "aci_rest" "fvRsSecInherited" {
  for_each   = { for ecm in var.esg_contract_masters : "uni/tn-${ecm.tenant}/ap-${ecm.application_profile}/esg-${ecm.endpoint_security_group}" => ecm }
  dn         = "${aci_rest.fvESg.dn}/rssecInherited-[${each.key}]"
  class_name = "fvRsSecInherited"
  content = {
    tDn = each.key
  }
}

resource "aci_rest" "fvTagSelector" {
  for_each   = { for ts in var.tag_selectors : "${ts.key}-${ts.operator != null ? ts.operator : "equals"}-${ts.value}" => ts }
  dn         = "${aci_rest.fvESg.dn}/tagselectorkey-[${each.value.key}]-value-[${each.value.value}]"
  class_name = "fvTagSelector"
  content = {
    descr         = each.value.description != null ? each.value.description : ""
    matchKey      = each.value.key
    matchValue    = each.value.value
    valueOperator = each.value.operator != null ? each.value.operator : "equals"
  }
}

resource "aci_rest" "fvEPgSelector" {
  for_each   = { for epgs in var.epg_selectors : "uni/tn-${epgs.tenant}/ap-${epgs.application_profile}/epg-${epgs.endpoint_group}" => epgs }
  dn         = "${aci_rest.fvESg.dn}/epgselector-[${each.key}]"
  class_name = "fvEPgSelector"
  content = {
    descr      = each.value.description != null ? each.value.description : ""
    matchEpgDn = each.key
  }

  depends_on = [aci_rest.fvRsProv]
}

resource "aci_rest" "fvEPSelector" {
  for_each   = { for iss in var.ip_subnet_selectors : "ip=='${iss.value}'" => iss }
  dn         = "${aci_rest.fvESg.dn}/epselector-[${each.key}]"
  class_name = "fvEPSelector"
  content = {
    descr           = each.value.description != null ? each.value.description : ""
    matchExpression = each.key
  }
}
