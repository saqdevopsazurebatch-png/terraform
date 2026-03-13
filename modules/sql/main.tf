resource "random_integer" "suffix" {
  min = 1000
  max = 9999
}

resource "azurerm_mssql_server" "sql" {
  name                         = "sql-${random_integer.suffix.result}"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_user
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "db" {
  count     = 4
  name      = "db${count.index + 1}"
  server_id = azurerm_mssql_server.sql.id
  sku_name  = "Basic"
}
