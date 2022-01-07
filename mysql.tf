
# Create a MySql database
# https://github.com/LexisNexis-RBA/terraform-azurerm-mysql-server
module "azurerm_mysql_server" {

    source = "github.com/LexisNexis-RBA/terraform-azurerm-mysql-server.git"
  
    location              = var.names.location
    resource_group_name   = var.resource_group_name
    names                 = var.names
    tags                  = merge(module.metadata.tags, { environment = var.names.environment, app = var.names.product_name })
    server_id             = var.server_id
    service_endpoints     = {
        "mysql" = var.private_subnet_id
    }

    mysql_server_parameters = {
        "log_bin_trust_function_creators" = "on"
    }
}

resource "azurerm_mysql_firewall_rule" "allow_azure_services" {
  name                = "Allow-Azure-Services"
  resource_group_name = var.resource_group_name
  server_name         = module.azurerm_mysql_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_private_endpoint" "mysqlEndpoint" {
  name                = "${var.names.mysql}-private-endpoint"
  location            = var.names.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_subnet_id

  private_service_connection {
    name                           = "${var.names.mysql}-private-connection"
    private_connection_resource_id = module.azurerm_mysql_server.id
    is_manual_connection           = false
    subresource_names              = ["mysqlServer"]
  }
}