resource "azurerm_dns_a_record" "record" {
  depends_on = [ helm_release.nginx_ingress ] 

  name                = var.dns_a_record_name
  zone_name           = var.parent_domain
  resource_group_name = var.parent_domain_resource_group_name
  ttl                 = 3600
  records             = [data.kubernetes_service.service_ingress.status[0].load_balancer[0].ingress[0].ip]
}