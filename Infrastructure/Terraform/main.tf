#############
# Providers #
#############

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=2.40.0"
    }    
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.0.2"
    }
  }
}

#Azure provider
provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

#####################
# Pre-Build Modules #
#####################

module "subscription" {
  source = "github.com/Azure-Terraform/terraform-azurerm-subscription-data.git?ref=v1.0.0"
  subscription_id = var.subscription_id
}

module "rules" {
  source = "github.com/LexisNexis-RBA/terraform-azurerm-naming.git?ref=v1.0.26"
}

module "metadata" {
  source = "github.com/Azure-Terraform/terraform-azurerm-metadata.git?ref=v1.5.0"

  naming_rules = module.rules.yaml

  market              = "us"
  location            = var.names.location # for location list see - https://github.com/openrba/python-azure-naming#rbaazureregion
  sre_team            = ""
  environment         = var.names.environment # for environment list see - https://github.com/openrba/python-azure-naming#rbaenvironment
  project             = ""
  business_unit       = "businesssvc"
  product_group       = var.names.product_group
  product_name        = var.names.product_name # for product name list see - https://github.com/openrba/python-azure-naming#rbaproductname
  subscription_id     = module.subscription.output.subscription_id
  subscription_type   = var.names.subscription_type
  resource_group_type = var.names.resource_group_type
}