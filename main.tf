resource "azurerm_public_ip" "publicip" {
  count               = var.public_ip_name != null || var.appgw_sku_tier == "Standard_v2" || var.appgw_sku_tier == "WAF_v2" ? 1 : 0
  name                = var.public_ip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.appgw_sku_tier == "Standard" || var.appgw_sku_tier == "WAF" ? "Dynamic" : "Static"
  sku                 = var.appgw_sku_tier == "Standard" || var.appgw_sku_tier == "WAF" ? "Basic" : "Standard"
  domain_name_label   = var.domain_name_label
  tags                = var.tags
}

resource "azurerm_application_gateway" "app-gateway" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  enable_http2        = var.enable_http2
  zones               = var.zones
  firewall_policy_id  = var.appgw_sku_tier == "WAF_v2" || var.appgw_sku_tier == "WAF" ? var.firewall_policy_id : null
  tags                = var.tags

  sku {
    name     = var.appgw_sku_name
    tier     = var.appgw_sku_tier
    capacity = var.autoscale_configuration == null ? var.capacity : null
  }

  dynamic "autoscale_configuration" {
    for_each = var.autoscale_configuration != null ? [var.autoscale_configuration] : []
    content {
      min_capacity = lookup(autoscale_configuration.value, "min_capacity")
      max_capacity = lookup(autoscale_configuration.value, "max_capacity")
    }
  }

  dynamic "identity" {
    for_each = var.identity_ids != null ? [1] : []
    content {
      type         = "UserAssigned"
      identity_ids = var.identity_ids
    }
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = var.subnet_id
  }

  dynamic "frontend_port" {
    for_each = var.frontend_port
    content {
      name = frontend_port.key
      port = frontend_port.value.port
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.public_ip_name != null ? [1] : []
    content {
      name                 = "appGwPublicFrontendIp"
      public_ip_address_id = azurerm_public_ip.publicip[0].id
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.private_ip_address != null ? [1] : []
    content {
      name                          = "appGwPrivateFrontendIp"
      subnet_id                     = var.subnet_id
      private_ip_address            = var.private_ip_address
      private_ip_address_allocation = "Static"
    }
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools
    content {
      name         = backend_address_pool.key
      ip_addresses = backend_address_pool.value.ip_addresses
      fqdns        = backend_address_pool.value.fqdns
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    content {
      name                                = backend_http_settings.key
      path                                = backend_http_settings.value.path
      port                                = backend_http_settings.value.port
      protocol                            = backend_http_settings.value.protocol
      request_timeout                     = backend_http_settings.value.request_timeout
      probe_name                          = backend_http_settings.value.probe_name
      cookie_based_affinity               = backend_http_settings.value.cookie_based_affinity
      affinity_cookie_name                = backend_http_settings.value.affinity_cookie_name
      pick_host_name_from_backend_address = backend_http_settings.value.pick_host_name_from_backend_address
      host_name                           = backend_http_settings.value.host_name
      connection_draining {
        enabled           = backend_http_settings.value.conn_draining_enabled
        drain_timeout_sec = backend_http_settings.value.conn_draining_timeout
      }
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listeners
    content {
      name                           = http_listener.key
      frontend_ip_configuration_name = var.http_listeners[http_listener.key].frontend_ip_configuration_name
      frontend_port_name             = var.http_listeners[http_listener.key].frontend_port_name
      protocol                       = var.http_listeners[http_listener.key].protocol
      ssl_certificate_name           = var.http_listeners[http_listener.key].ssl_certificate_name
      host_name                      = var.http_listeners[http_listener.key].host_name
      host_names                     = var.http_listeners[http_listener.key].host_names
    }
  }

  dynamic "probe" {
    for_each = var.probes
    content {
      name                                      = probe.key
      interval                                  = probe.value.interval
      path                                      = probe.value.path
      protocol                                  = probe.value.protocol
      timeout                                   = probe.value.timeout
      unhealthy_threshold                       = probe.value.unhealthy_threshold
      pick_host_name_from_backend_http_settings = probe.value.pick_host_name_from_backend_http_settings
      host                                      = probe.value.host
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.routing_rules
    content {
      name                        = request_routing_rule.key
      rule_type                   = request_routing_rule.value.rule_type
      http_listener_name          = request_routing_rule.value.http_listener_name
      backend_address_pool_name   = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name  = request_routing_rule.value.backend_http_settings_name
      redirect_configuration_name = request_routing_rule.value.redirect_configuration_name
      priority                    = request_routing_rule.value.priority
      url_path_map_name           = request_routing_rule.value.url_path_map_name
      rewrite_rule_set_name       = request_routing_rule.value.rewrite_rule_set_name
    }
  }

  dynamic "redirect_configuration" {
    for_each = var.redirect_configs

    content {
      name                 = redirect_configuration.key
      redirect_type        = redirect_configuration.value.redirect_type
      target_listener_name = redirect_configuration.value.target_listener_name
      target_url           = redirect_configuration.value.target_url
      include_path         = redirect_configuration.value.include_path
      include_query_string = redirect_configuration.value.include_query_string
    }
  }

  dynamic "ssl_certificate" {
    for_each = var.ssl_certificates

    content {
      name                = ssl_certificate.key
      data                = ssl_certificate.value.key_vault_secret_id == null ? filebase64(ssl_certificate.value.data) : null
      password            = ssl_certificate.value.key_vault_secret_id == null ? ssl_certificate.value.password : null
      key_vault_secret_id = lookup(ssl_certificate.value, "key_vault_secret_id", null)
    }
  }

  dynamic "trusted_root_certificate" {
    for_each = var.trusted_root_certificates
    content {
      name                = trusted_root_certificate.key
      data                = trusted_root_certificate.value.kv_trusted_cert_id == null ? trusted_root_certificate.value.data : null
      key_vault_secret_id = lookup(trusted_root_certificate.value, "kv_trusted_cert_id", null)
    }
  }

  dynamic "url_path_map" {
    for_each = var.url_path_map
    content {
      name                                = url_path_map.key
      default_backend_address_pool_name   = url_path_map.value.default_backend_address_pool_name
      default_backend_http_settings_name  = url_path_map.value.default_backend_http_settings_name
      default_redirect_configuration_name = url_path_map.value.default_redirect_configuration_name
      default_rewrite_rule_set_name       = url_path_map.value.default_rewrite_rule_set_name
      dynamic "path_rule" {
        for_each = length(url_path_map.value.path_rule) > 0 ? url_path_map.value.path_rule : {}
        content {
          name                        = path_rule.key
          paths                       = path_rule.value.paths
          backend_address_pool_name   = path_rule.value.backend_address_pool_name
          backend_http_settings_name  = path_rule.value.backend_http_settings_name
          rewrite_rule_set_name       = path_rule.value.rewrite_rule_set_name
          redirect_configuration_name = path_rule.value.redirect_configuration_name
        }
      }
    }
  }

  dynamic "rewrite_rule_set" {
    for_each = var.rewrite_rule_sets
    content {
      name = rewrite_rule_set.key
      dynamic "rewrite_rule" {
        for_each = length(rewrite_rule_set.value.rewrite_rule) > 0 ? rewrite_rule_set.value.rewrite_rule : {}
        content {
          name          = rewrite_rule.key
          rule_sequence = rewrite_rule.value.rule_sequence
          dynamic "condition" {
            for_each = length(rewrite_rule.value.condition) > 0 ? rewrite_rule.value.condition : []
            content {
              variable    = condition.value.variable
              pattern     = condition.value.pattern
              ignore_case = condition.value.ignore_case
              negate      = condition.value.negate
            }
          }
          dynamic "request_header_configuration" {
            for_each = length(rewrite_rule.value.request_header_configuration) > 0 ? rewrite_rule.value.request_header_configuration : []
            content {
              header_name  = request_header_configuration.value.header_name
              header_value = request_header_configuration.value.header_value
            }
          }
          dynamic "response_header_configuration" {
            for_each = length(rewrite_rule.value.response_header_configuration) > 0 ? rewrite_rule.value.response_header_configuration : []
            content {
              header_name  = response_header_configuration.value.header_name
              header_value = response_header_configuration.value.header_value
            }
          }
        }
      }
    }
  }

  dynamic "waf_configuration" {
    for_each = var.inbuilt_waf_configs.enabled ? [1] : []
    content {
      enabled          = var.inbuilt_waf_configs.enabled
      firewall_mode    = var.inbuilt_waf_configs.firewall_mode
      rule_set_type    = var.inbuilt_waf_configs.rule_set_type
      rule_set_version = var.inbuilt_waf_configs.rule_set_version
      dynamic "exclusion" {
        for_each = var.inbuilt_waf_configs.exclusions
        content {
          match_variable          = exclusion.value.match_variable
          selector_match_operator = exclusion.value.selector_match_operator
          selector                = exclusion.value.selector
        }
      }
      dynamic "disabled_rule_group" {
        for_each = var.inbuilt_waf_configs.disabled_rule_groups
        content {
          rule_group_name = disabled_rule_group.value.rule_group_name
          rules           = disabled_rule_group.value.rules
        }
      }

    }
  }

}

resource "azurerm_monitor_diagnostic_setting" "public-ip-diag" {
  count                          = var.public_ip_name != null || var.appgw_sku_tier == "Standard_v2" || var.appgw_sku_tier == "WAF_v2" ? 1 : 0
  name                           = var.publicip_diag_name
  target_resource_id             = azurerm_public_ip.publicip[0].id
  storage_account_id             = var.storage_account_id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  eventhub_authorization_rule_id = var.eventhub_authorization_rule_id

  dynamic "log" {
    for_each = var.pip_diag_logs
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = false
        days    = 0
      }
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  lifecycle {
    ignore_changes = [log, metric]
  }
}

resource "azurerm_monitor_diagnostic_setting" "agw-diag" {
  name                           = var.agw_diag_name
  target_resource_id             = azurerm_application_gateway.app-gateway.id
  storage_account_id             = var.storage_account_id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  eventhub_authorization_rule_id = var.eventhub_authorization_rule_id

  dynamic "log" {
    for_each = var.agw_diag_logs
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
        days    = 7
      }
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 7
    }
  }

  lifecycle {
    ignore_changes = [log, metric]
  }
}
