module "azurerm_log_analytics_workspace" {
    source = "github.com/LexisNexis-RBA/terraform-azurerm-log-analytics-workspace.git"
    
    resource_group_name   = var.resource_group_name
    tags                  = merge(module.metadata.tags, { environment = var.names.environment, app = var.names.product_name })    

    analyticWorkspaces = {
      "app" = {
        workspaceName            = var.names_analytics.workspace
        workspaceLocation        = var.names.location
        workspaceSKU             = var.names_analytics.sku
        workspaceRetentionInDays = var.names_analytics.retention_days
      }
  }
}

resource "azurerm_log_analytics_solution" "containerInsights" {
  solution_name         = var.names_analytics.name
  location              = var.names.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = module.azurerm_log_analytics_workspace.workspaces[0].app.id
  workspace_name        = module.azurerm_log_analytics_workspace.workspaces[0].app.name
  tags                  = merge(module.metadata.tags, { environment = var.names.environment, app = var.names.product_name })

  plan {
    publisher = var.names_analytics.publisher
    product   = var.names_analytics.product
  }
}