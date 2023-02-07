## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_gateway.app-gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) | resource |
| [azurerm_monitor_diagnostic_setting.agw-diag](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.public-ip-diag](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_public_ip.publicip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agw_diag_logs"></a> [agw\_diag\_logs](#input\_agw\_diag\_logs) | Application Gateway Monitoring Category details for Azure Diagnostic setting | `list(string)` | <pre>[<br>  "ApplicationGatewayAccessLog",<br>  "ApplicationGatewayPerformanceLog",<br>  "ApplicationGatewayFirewallLog"<br>]</pre> | no |
| <a name="input_agw_diag_name"></a> [agw\_diag\_name](#input\_agw\_diag\_name) | Diagnostic settings name for Application Gateway | `string` | n/a | yes |
| <a name="input_appgw_sku_name"></a> [appgw\_sku\_name](#input\_appgw\_sku\_name) | The Name of the SKU to use for this Application Gateway. Possible values are Standard\_Small, Standard\_Medium, Standard\_Large, Standard\_v2, WAF\_Medium, WAF\_Large, and WAF\_v2 | `string` | n/a | yes |
| <a name="input_appgw_sku_tier"></a> [appgw\_sku\_tier](#input\_appgw\_sku\_tier) | The Tier of the SKU to use for this Application Gateway. Possible values are Standard, Standard\_v2, WAF and WAF\_v2 | `string` | n/a | yes |
| <a name="input_autoscale_configuration"></a> [autoscale\_configuration](#input\_autoscale\_configuration) | Minimum or Maximum capacity for autoscaling. Accepted values are for Minimum in the range 0 to 100 and for Maximum in the range 2 to 125 | <pre>object({<br>    min_capacity = number<br>    max_capacity = number<br>  })</pre> | `null` | no |
| <a name="input_backend_address_pools"></a> [backend\_address\_pools](#input\_backend\_address\_pools) | Name, IP Address and FQDN details of the backend address pool | <pre>map(object({<br>    ip_addresses = list(string)<br>    fqdns        = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_backend_http_settings"></a> [backend\_http\_settings](#input\_backend\_http\_settings) | Backend HTTP settings | <pre>map(object({<br>    path                                = string<br>    protocol                            = string<br>    port                                = number<br>    request_timeout                     = number<br>    probe_name                          = string<br>    conn_draining_enabled               = bool<br>    conn_draining_timeout               = number<br>    cookie_based_affinity               = string<br>    affinity_cookie_name                = string<br>    pick_host_name_from_backend_address = bool<br>    host_name                           = string<br>  }))</pre> | n/a | yes |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | The Capacity of the SKU to use for this Application Gateway. When using a V1 SKU this value must be between 1 and 32, and 1 to 125 for a V2 SKU. This property is optional if autoscale\_configuration is set. | `number` | n/a | yes |
| <a name="input_domain_name_label"></a> [domain\_name\_label](#input\_domain\_name\_label) | Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system. | `string` | `null` | no |
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | Is HTTP2 enabled on the application gateway resource? Defaults to false | `bool` | `null` | no |
| <a name="input_eventhub_authorization_rule_id"></a> [eventhub\_authorization\_rule\_id](#input\_eventhub\_authorization\_rule\_id) | Event Hub Authorization Rule id for diagnostic settings | `string` | `null` | no |
| <a name="input_firewall_policy_id"></a> [firewall\_policy\_id](#input\_firewall\_policy\_id) | WAF Firewall Policy id to link to this app gateway | `string` | `null` | no |
| <a name="input_frontend_port"></a> [frontend\_port](#input\_frontend\_port) | Front end port details | <pre>map(object({<br>    port = number<br>  }))</pre> | n/a | yes |
| <a name="input_http_listeners"></a> [http\_listeners](#input\_http\_listeners) | The listener details for this app gateway | <pre>map(object({<br>    frontend_ip_configuration_name = string<br>    frontend_port_name             = string<br>    protocol                       = string<br>    host_name                      = string<br>    host_names                     = list(string)<br>    ssl_certificate_name           = string<br>  }))</pre> | n/a | yes |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | Specifies a list of User Assigned Managed Identity IDs to be assigned to this Application Gateway | `list(string)` | `null` | no |
| <a name="input_inbuilt_waf_configs"></a> [inbuilt\_waf\_configs](#input\_inbuilt\_waf\_configs) | Details of WAF that can be configured along with application gateway | <pre>object({<br>    enabled          = bool<br>    firewall_mode    = string<br>    rule_set_type    = string<br>    rule_set_version = string<br>    exclusions = list(object({<br>      match_variable          = string<br>      selector_match_operator = string<br>      selector                = string<br>    }))<br>    disabled_rule_groups = list(object({<br>      rule_group_name = string<br>      rules           = list(string)<br>    }))<br>  })</pre> | <pre>{<br>  "disabled_rule_groups": [],<br>  "enabled": false,<br>  "exclusions": [],<br>  "firewall_mode": null,<br>  "rule_set_type": null,<br>  "rule_set_version": null<br>}</pre> | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region where the Application Gateway should exist. Changing this forces a new resource to be created. | `string` | `"eastus"` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | Log Analytics Workspace id for diagnostic settings | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the application gateway | `string` | n/a | yes |
| <a name="input_pip_diag_logs"></a> [pip\_diag\_logs](#input\_pip\_diag\_logs) | Load balancer Public IP Monitoring Category details for Azure Diagnostic setting | `list(string)` | <pre>[<br>  "DDoSProtectionNotifications",<br>  "DDoSMitigationFlowLogs",<br>  "DDoSMitigationReports"<br>]</pre> | no |
| <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address) | private ip address for this app gateway | `string` | n/a | yes |
| <a name="input_probes"></a> [probes](#input\_probes) | Health Probes to be created in this app gateway | <pre>map(object({<br>    interval                                  = number<br>    path                                      = string<br>    protocol                                  = string<br>    timeout                                   = number<br>    unhealthy_threshold                       = number<br>    pick_host_name_from_backend_http_settings = bool<br>    host                                      = string<br>  }))</pre> | n/a | yes |
| <a name="input_public_ip_name"></a> [public\_ip\_name](#input\_public\_ip\_name) | The name of a Public IP Address which the Application Gateway should use. V2 always rquires a public ip address. If you would like to make V2 app gateway as private, please follow the link - https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-faq#how-do-i-use-application-gateway-v2-with-only-private-frontend-ip-address | `string` | `null` | no |
| <a name="input_publicip_diag_name"></a> [publicip\_diag\_name](#input\_publicip\_diag\_name) | Diagnostic settings name for Public IP | `string` | `null` | no |
| <a name="input_redirect_configs"></a> [redirect\_configs](#input\_redirect\_configs) | Redirection details if any for this app gateway | <pre>map(object({<br>    redirect_type        = string<br>    target_listener_name = string<br>    target_url           = string<br>    include_path         = string<br>    include_query_string = string<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to the Application Gateway should exist. | `string` | n/a | yes |
| <a name="input_rewrite_rule_sets"></a> [rewrite\_rule\_sets](#input\_rewrite\_rule\_sets) | Rewrite rule set details | <pre>map(object({<br>    rewrite_rule = map(object({<br>      rule_sequence = number<br>      condition = list(object({<br>        variable    = string<br>        pattern     = string<br>        ignore_case = string<br>        negate      = string<br>      }))<br>      request_header_configuration = list(object({<br>        header_name  = string<br>        header_value = string<br>      }))<br>      response_header_configuration = list(object({<br>        header_name  = string<br>        header_value = string<br>      }))<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_routing_rules"></a> [routing\_rules](#input\_routing\_rules) | Routing rules that determines the traffic destination | <pre>map(object({<br>    rule_type                   = string<br>    http_listener_name          = string<br>    backend_address_pool_name   = string<br>    backend_http_settings_name  = string<br>    redirect_configuration_name = string<br>    priority                    = number<br>    url_path_map_name           = string<br>    rewrite_rule_set_name       = string<br>  }))</pre> | n/a | yes |
| <a name="input_ssl_certificates"></a> [ssl\_certificates](#input\_ssl\_certificates) | SSL Certificate details if its listening on port 443 | <pre>map(object({<br>    data                = string<br>    password            = string<br>    key_vault_secret_id = string<br>  }))</pre> | `{}` | no |
| <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id) | Storage account id for diagnostic settings | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the Subnet. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | n/a | yes |
| <a name="input_trusted_root_certificates"></a> [trusted\_root\_certificates](#input\_trusted\_root\_certificates) | Trusted CA Cert details if its not a well known CA | <pre>map(object({<br>    data               = string<br>    kv_trusted_cert_id = string<br>  }))</pre> | `{}` | no |
| <a name="input_url_path_map"></a> [url\_path\_map](#input\_url\_path\_map) | URL Path based Routing details. This is required if routing rule type is set as PathBasedRouting | <pre>map(object({<br>    default_backend_address_pool_name   = string<br>    default_backend_http_settings_name  = string<br>    default_redirect_configuration_name = string<br>    default_rewrite_rule_set_name       = string<br>    path_rule = map(object({<br>      paths                      = list(string)<br>      backend_http_settings_name = string<br>      backend_address_pool_name  = string<br>      rewrite_rule_set_name      = string<br>      redirect_configuration_name = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | A list of Availability Zones | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_gateway_id"></a> [app\_gateway\_id](#output\_app\_gateway\_id) | The ID of the Application Gateway. |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | n/a |
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | n/a |
