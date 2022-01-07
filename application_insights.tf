module "azurerm_application_insights" {
    source = "github.com/LexisNexis-RBA/terraform-azurerm-application-insights.git"

    insights_name       = var.app_insights_name
    location            = module.metadata.location
    resource_group_name = var.resource_group_name
    application_type    = "web"
}