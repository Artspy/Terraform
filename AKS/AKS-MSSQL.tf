#-------------------> Azure SQL Server
resource "azurerm_sql_server" "fitverse-sql-server" {
  name                         = "fitverse-sql-server"
  resource_group_name          = azurerm_resource_group.RG-DATABASES.name
  location                     = azurerm_resource_group.RG-DATABASES.location
  version                      = "12.0"
  administrator_login          = var.ms_db_login
  administrator_login_password = var.ms_db_password

  tags = {
      environment = var.tagprod
  }
}

#-------------------> Azure SQL Storage Account
resource "azurerm_storage_account" "fitversesa" {
  name                          = "fitversesa"
  resource_group_name           = azurerm_resource_group.RG-DATABASES.name
  location                      = azurerm_resource_group.RG-DATABASES.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
}

#-------------------> Azure SQL Database - MembersService
resource "azurerm_mssql_database" "fitverse_ms_db" {
  name           = "-"
  server_id      = azurerm_sql_server.fitverse-sql-server.id
  sku_name       = "S0"

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.fitversesa.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.fitversesa.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 7
  }

  tags = {
      environment = var.tagprod
  }

}

#-------------------> Azure SQL Database - AgreementsService
resource "azurerm_mssql_database" "fitverse_as_db" {
  name           = "-"
  server_id      = azurerm_sql_server.fitverse-sql-server.id
  sku_name       = "S0"

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.fitversesa.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.fitversesa.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 7
  }

  tags = {
      environment = var.tagprod
  }

}

#-------------------> Azure SQL Database - CalendarService
resource "azurerm_mssql_database" "fitverse_cs_db" {
  name           = "-"
  server_id      = azurerm_sql_server.fitverse-sql-server.id
  sku_name       = "S0"

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.fitversesa.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.fitversesa.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 7
  }

  tags = {
      environment = var.tagprod
  }

}

#-------------------> Azure SQL Database - AuthService
resource "azurerm_mssql_database" "fitverse_auth_db" {
  name           = "-"
  server_id      = azurerm_sql_server.fitverse-sql-server.id
  sku_name       = "S0"

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.fitversesa.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.fitversesa.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 7
  }

  tags = {
      environment = var.tagprod
  }

}
