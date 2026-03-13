output "sql_server_name" {
  value = azurerm_mssql_server.sql.name
}

output "databases" {
  value = [for db in azurerm_mssql_database.db : db.name]
}
