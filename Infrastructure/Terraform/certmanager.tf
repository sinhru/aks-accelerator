module "cert_manager" {
  source = "github.com/Azure-Terraform/terraform-azurerm-kubernetes-cert-manager.git?ref=v1.0.3"

  subscription_id = module.subscription.output.subscription_id

  names                       = var.names
  location                    = module.metadata.location
  resource_group_name         = var.resource_group_name
  tags                        = merge(module.metadata.tags, { environment = var.names.environment, app = var.names.product_name })

  cert_manager_version        = "v1.3.0" 

  domains = { (var.parent_domain) = var.dns_zone_id } 

  issuers = {
    staging = {
      namespace            = "cert-manager"
      cluster_issuer       = true
      email_address        = var.email_address
      domain               = var.parent_domain
      letsencrypt_endpoint = "staging"
    }
    #   production = {
    #     namespace             = "cert-manager"
    #     cluster_issuer        = true
    #     email_address         = var.email_address
    #     domain                = module.dns.name
    #     letsencrypt_endpoint  = "production"
    #   }
  }
}

module "certificate" {
  source = "github.com/Azure-Terraform/terraform-azurerm-kubernetes-cert-manager.git//certificate?ref=v1.0.2"

  depends_on = [module.cert_manager]

  providers = { helm = helm.aks }

  certificate_name = var.cert_name
  namespace        = "cert-manager"
  secret_name      = "cert-manager-issuer-staging"
  issuer_ref_name  = module.cert_manager.issuers[var.certificate_type]

  dns_names = [
      trim(azurerm_dns_a_record.record.fqdn, "."), 
    ]
}