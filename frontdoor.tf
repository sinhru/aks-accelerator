resource "azurerm_frontdoor" "frontdoor" {
  name                                         = var.names_frontdoor.name
  location                                     = "global"
  resource_group_name                          = var.resource_group_name
  enforce_backend_pools_certificate_name_check = true
  backend_pools_send_receive_timeout_seconds   = 30

  routing_rule {
    name               = var.names_frontdoor.name
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = var.frontend_endpoints
    forwarding_configuration {
      forwarding_protocol = var.names_frontdoor.routing_rule_protocol
      backend_pool_name   = "${var.names_frontdoor.name}-backend"
    }
  }

  backend_pool_load_balancing {
    name = "${var.names_frontdoor.name}-loadbalancer"
  }

  backend_pool_health_probe {
    name = "${var.names_frontdoor.name}-healthprobe"
    path = var.health_probe.path
    protocol = var.health_probe.protocol
    probe_method = var.health_probe.probe_method
    interval_in_seconds = var.health_probe.interval_in_seconds
  }

  backend_pool {
    name = "${var.names_frontdoor.name}-backend"
    backend {
      host_header = var.backend_pool.host_header
      address     = var.backend_pool.address
      http_port   = var.backend_pool.http_port
      https_port  = var.backend_pool.https_port
    }

    load_balancing_name = "${var.names_frontdoor.name}-loadbalancer"
    health_probe_name   = "${var.names_frontdoor.name}-healthprobe"
  }

  frontend_endpoint {
    name      = "${var.names_frontdoor.name}-azurefd-net"
    host_name = "${var.names_frontdoor.name}.azurefd.net"
  }
}