variable "name" {
  description = "Endpoint security group name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "application_profile" {
  description = "Application profile name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.application_profile))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "vrf" {
  description = "VRF name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.vrf))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "shutdown" {
  description = "Shutdown."
  type        = bool
  default     = false
}

variable "intra_esg_isolation" {
  description = "Intra ESG isolation."
  type        = bool
  default     = false
}

variable "preferred_group" {
  description = "Preferred group membership."
  type        = bool
  default     = false
}

variable "contracts" {
  description = "Contracts."
  type = object({
    consumers = optional(list(string))
    providers = optional(list(string))
  })
  default = {}

  validation {
    condition = alltrue([
      for con in coalesce(var.contracts.consumers, []) : can(regex("^[a-zA-Z0-9_.-]{0,64}$", con))
    ])
    error_message = "`consumers`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for prov in coalesce(var.contracts.providers, []) : can(regex("^[a-zA-Z0-9_.-]{0,64}$", prov))
    ])
    error_message = "`providers`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "esg_contract_masters" {
  description = "List of ESG contract masters."
  type = list(object({
    tenant                  = string
    application_profile     = string
    endpoint_security_group = string
  }))
  default = []

  validation {
    condition = alltrue([
      for ecm in var.esg_contract_masters : can(regex("^[a-zA-Z0-9_.-]{0,64}$", ecm.tenant))
    ])
    error_message = "`tenant`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for ecm in var.esg_contract_masters : can(regex("^[a-zA-Z0-9_.-]{0,64}$", ecm.application_profile))
    ])
    error_message = "`application_profile`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for ecm in var.esg_contract_masters : can(regex("^[a-zA-Z0-9_.-]{0,64}$", ecm.endpoint_security_group))
    ])
    error_message = "`endpoint_security_group`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "tag_selectors" {
  description = "List of tag selectors.  Choices `operator`: `contains`, `equals`, `regex`. Default value `operator`: `equals`. Default value `description`: ''"
  type = list(object({
    key         = string
    operator    = optional(string)
    value       = string
    description = optional(string)
  }))
  default = []

  # No validation for key

  validation {
    condition = alltrue([
      for ts in var.tag_selectors : ts.operator == null || try(contains(["contains", "equals", "regex"], ts.operator), false)
    ])
    error_message = "`operator`: Valid values are `contains`, `equals`, `regex`."
  }

  # No validation for value

  validation {
    condition = alltrue([
      for ts in var.tag_selectors : ts.description == null || can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", ts.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "epg_selectors" {
  description = "List of epg selectors. Format TBD"
  type = list(object({
    tenant              = string
    application_profile = string
    endpoint_group      = string
    description         = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for epgs in var.epg_selectors : can(regex("^[a-zA-Z0-9_.-]{0,64}$", epgs.tenant))
    ])
    error_message = "`tenant`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for epgs in var.epg_selectors : can(regex("^[a-zA-Z0-9_.-]{0,64}$", epgs.application_profile))
    ])
    error_message = "`application_profile`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for epgs in var.epg_selectors : can(regex("^[a-zA-Z0-9_.-]{0,64}$", epgs.endpoint_group))
    ])
    error_message = "`endpoint_group`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for epgs in var.epg_selectors : epgs.description == null || can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", epgs.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "ip_subnet_selectors" {
  description = "List of ip subnet selectors. Format TBD"
  type = list(object({
    key         = optional(string)
    operator    = optional(string)
    value       = string
    description = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for iss in var.ip_subnet_selectors : iss.key == null || try(contains(["ip"], iss.key), false)
    ])
    error_message = "`key`: Valid values are `ip`."
  }

  validation {
    condition = alltrue([
      for iss in var.ip_subnet_selectors : iss.operator == null || try(contains(["equals"], iss.operator), false)
    ])
    error_message = "`operator`: Valid values are `equals`."
  }

  validation {
    condition = alltrue([
      for iss in var.ip_subnet_selectors : can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}\\/([0-9]){1,2}$", iss.value))
    ])
    error_message = "`value`: Valid ip format example: 192.168.1.0/24."
  }

  validation {
    condition = alltrue([
      for iss in var.ip_subnet_selectors : iss.description == null || can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", iss.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}