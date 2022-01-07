# Create a Azure Container Registry
# https://github.com/openrba/terraform-azurerm-container-registry
module "azurerm_acr" {
  
  source = "github.com/LexisNexis-RBA/terraform-azurerm-container-registry.git?ref=v1.0.0"

  location              = var.names.location
  resource_group_name   = var.resource_group_name
  names                 = var.names
  tags                  = merge(module.metadata.tags, { environment = var.names.environment, app = var.names.product_name })
  disable_unique_suffix = true
  sku                   = var.sku
  admin_enabled         = var.admin_enabled

}


# Create a Azure Kubernetes Cluster
# https://github.com/Azure-Terraform/terraform-azurerm-kubernetes?ref=v1.2.0
# Forked - https://github.com/riesbl01/terraform-azurerm-kubernetes.git
module "azurerm_kubernetes_cluster" {

  source = "github.com/Azure-Terraform/terraform-azurerm-kubernetes.git?ref=v3.2.4"

  names                       = var.names
  kubernetes_version          = var.kubernetes_version
  location                    = module.metadata.location
  resource_group_name         = var.resource_group_name
  network_plugin              = "kubenet"
  enable_kube_dashboard       = false
  acr_pull_access             = var.acr_ids
  tags                        = merge(module.metadata.tags, { environment = var.names.environment, app = var.names.product_name })
  log_analytics_workspace_id  = module.azurerm_log_analytics_workspace.workspaces[0].app.id

  node_pool_subnets = {
    private = {
      id                          = var.private_subnet_id
      resource_group_name         = var.resource_group_name
      network_security_group_name = var.private_nsg_name
    }
    public = {
      id                          = var.public_subnet_id
      resource_group_name         = var.resource_group_name
      network_security_group_name = var.public_nsg_name
    }
  }

  node_pools = {
    public = {
      subnet              = "public"
      vm_size             = var.vm_size_E2_v3
      enable_auto_scaling = true
      min_count           = 1
      max_count           = 3
      availability_zones  = [1]
    }
    default = {
      subnet              = "private"
      vm_size             = var.vm_size_E2_v3
      enable_auto_scaling = true
      min_count           = 1
      max_count           = 3
      availability_zones  = [1]
    }
  }

  default_node_pool = "default"

  identity_type = "UserAssigned"
}