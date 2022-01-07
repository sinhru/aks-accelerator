# Basics

variable "subscription_id" {
  type        = string
  description = "the subscription id"
}

variable "resource_group_name"{
  description = "Resource group name."
  type        = string
}

variable "names" {
  description = "Names to be applied to resources."
  type        = map(string)
  default     = null
}

variable "names_analytics" {
  description = "names to be applied to container insight resources"
  type        = map(string)
}

variable "kubernetes_version" {
  description = "kubernetes version"
  type        = string
  default     = null # defaults to latest recommended version
}

variable "acr_ids" {
  description = "map of ACR ids to allow AcrPull"
  type        = map(string)
  default     = {}
}

variable "sku" {
  description = "SKU name."
  type        = string
}

variable "vm_size_E2_v3" {
  description = "E2 v3 VM size."
  type        = string
}

variable "admin_enabled" {
  description = "Specifies whether the admin user is enabled."
  default     = false
  type        = bool
}

variable "private_subnet_id" {
  description = "Id of the private subnet"
  type        = string
  default     = ""
}

variable "private_nsg_name" {
  description = "Private NSG name"
  type        = string
  default     = ""
}

variable "public_subnet_id" {
  description = "Id of the public subnet"
  type        = string
  default     = ""
}

variable "outbound_subnet_id" {
  description = "For my sql integration"
  type        = string
  default     = ""
}

variable "public_nsg_name" {
  description = "Public NSG name"
  type        = string
  default     = ""
}

variable "sql_subnet_id" {
  description = "Id of the sql subnet"
  type        = string
  default     = ""
}

variable "server_id" {
  description = "ID of Server"
  type        = string
  default     = ""
}

variable "backend_pool" {
  description = "Front Door backend pool configuration"
  type        = map(string)
  default     = {}
}

variable "frontend_endpoints" {
  description = "List of frontend endpoints"
  type        = list(string)
  default     = []
}

variable "names_frontdoor" {
  description = "List of names for Front Door configuration"
  type        = map(string)
  default     = {}
}

variable "health_probe" {
  description = "Front door health probe configurations"
  type        = map(string)
  default     = {}
}

variable "namespaces" {
  description = "List of Kubernetes Namespaces"
  type        = map(string)
  default     = {}
}

variable "parent_domain_resource_group_name" {
  type = string
}

variable "parent_domain_subscription_id" {
  type = string
}

variable "parent_domain" {
  type = string
}

variable "child_domain_prefixes" {
  type = list(string)
  default = [""]
}

variable "hostname" {
  type    = string
  default = ""
}

variable "email_address" {
  type        = string
  description = "Email of the contact person"
}

variable "certificate_type" {
  type        = string
  description = "staging or production"
  default     = "staging"
}

variable "dns_a_record_name" {
  type        = string
  description = "Name of DNS A record"
  default     = "" 
}

variable "ingress_name" {
  type        = string
  description = "Name of ingress controller"
  default     = ""
}

variable "ingress_class" {
  type        = string
  description = "Ingress class"
  default     = "" 
}

variable "app_insights_name" {
  type        = string
  description = "Application Insights name"
  default     = ""
}

variable "dns_zone_id" {
  type        = string
  description = "DNS Zone resource Id"
  default     = ""
}

variable "cert_name" {
  type        = string
  description = "Name of certificate"
  default     = ""  
}