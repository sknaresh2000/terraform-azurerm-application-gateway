variable "public_ip_name" {
  type        = string
  description = "The name of a Public IP Address which the Application Gateway should use. V2 always rquires a public ip address. If you would like to make V2 app gateway as private, please follow the link - https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-faq#how-do-i-use-application-gateway-v2-with-only-private-frontend-ip-address "
  default     = null
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to the Application Gateway should exist. "
}

variable "location" {
  type        = string
  description = "The Azure region where the Application Gateway should exist. Changing this forces a new resource to be created."
  default     = "eastus"
}

variable "appgw_sku_name" {
  type        = string
  description = "The Name of the SKU to use for this Application Gateway. Possible values are Standard_Small, Standard_Medium, Standard_Large, Standard_v2, WAF_Medium, WAF_Large, and WAF_v2"
}

variable "appgw_sku_tier" {
  type        = string
  description = " The Tier of the SKU to use for this Application Gateway. Possible values are Standard, Standard_v2, WAF and WAF_v2"
}

variable "capacity" {
  type        = number
  description = "The Capacity of the SKU to use for this Application Gateway. When using a V1 SKU this value must be between 1 and 32, and 1 to 125 for a V2 SKU. This property is optional if autoscale_configuration is set."
}

variable "autoscale_configuration" {
  description = "Minimum or Maximum capacity for autoscaling. Accepted values are for Minimum in the range 0 to 100 and for Maximum in the range 2 to 125"
  type = object({
    min_capacity = number
    max_capacity = number
  })
  default = null
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
}

variable "zones" {
  type        = list(string)
  description = "A list of Availability Zones"
  default     = []
}

variable "enable_http2" {
  type        = bool
  description = "Is HTTP2 enabled on the application gateway resource? Defaults to false"
  default     = null
}

variable "subnet_id" {
  type        = string
  description = "The ID of the Subnet."
}

variable "identity_ids" {
  type        = list(string)
  description = "Specifies a list of User Assigned Managed Identity IDs to be assigned to this Application Gateway"
  default     = null
}

variable "name" {
  type        = string
  description = "The name of the application gateway"
}

variable "backend_address_pools" {
  type = map(object({
    ip_addresses = list(string)
    fqdns        = list(string)
  }))
  description = "Name, IP Address and FQDN details of the backend address pool"
}

variable "backend_http_settings" {
  type = map(object({
    path                                = string
    protocol                            = string
    port                                = number
    request_timeout                     = number
    probe_name                          = string
    conn_draining_enabled               = bool
    conn_draining_timeout               = number
    cookie_based_affinity               = string
    affinity_cookie_name                = string
    pick_host_name_from_backend_address = bool
    host_name                           = string
  }))
  description = "Backend HTTP settings"
}


variable "domain_name_label" {
  type        = string
  description = "Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
  default     = null
}

variable "http_listeners" {
  type = map(object({
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    protocol                       = string
    host_name                      = string
    host_names                     = list(string)
    ssl_certificate_name           = string
  }))
  description = "The listener details for this app gateway"
}

variable "ssl_certificates" {
  type = map(object({
    data                = string
    password            = string
    key_vault_secret_id = string
  }))
  default     = {}
  description = "SSL Certificate details if its listening on port 443"
}

variable "firewall_policy_id" {
  type        = string
  default     = null
  description = "WAF Firewall Policy id to link to this app gateway"
}
variable "probes" {
  type = map(object({
    interval                                  = number
    path                                      = string
    protocol                                  = string
    timeout                                   = number
    unhealthy_threshold                       = number
    pick_host_name_from_backend_http_settings = bool
    host                                      = string
  }))
  description = "Health Probes to be created in this app gateway"
}


variable "routing_rules" {
  type = map(object({
    rule_type                   = string
    http_listener_name          = string
    backend_address_pool_name   = string
    backend_http_settings_name  = string
    redirect_configuration_name = string
    priority                    = number
  }))
  description = "Routing rules that determines the traffic destination"
}

variable "frontend_port" {
  type = map(object({
    port = number
  }))
  description = "Front end port details"
}

variable "private_ip_address" {
  type        = string
  description = "private ip address for this app gateway"
}

variable "redirect_configs" {
  type = map(object({
    redirect_type        = string
    target_listener_name = string
    target_url           = string
    include_path         = string
    include_query_string = string
  }))
  description = "Redirection details if any for this app gateway"
  default     = {}
}

variable "agw_diag_logs" {
  description = "Application Gateway Monitoring Category details for Azure Diagnostic setting"
  type        = list(string)
  default     = ["ApplicationGatewayAccessLog", "ApplicationGatewayPerformanceLog", "ApplicationGatewayFirewallLog"]
}

variable "pip_diag_logs" {
  description = "Load balancer Public IP Monitoring Category details for Azure Diagnostic setting"
  type        = list(string)
  default     = ["DDoSProtectionNotifications", "DDoSMitigationFlowLogs", "DDoSMitigationReports"]
}

variable "eventhub_authorization_rule_id" {
  description = "Event Hub Authorization Rule id for diagnostic settings"
  type        = string
  default     = null
}

variable "storage_account_id" {
  description = "Storage account id for diagnostic settings"
  type        = string
  default     = null
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace id for diagnostic settings"
  type        = string
}

variable "publicip_diag_name" {
  description = "Diagnostic settings name for Public IP"
  type        = string
  default     = null
}

variable "agw_diag_name" {
  description = "Diagnostic settings name for Application Gateway"
  type        = string
}

