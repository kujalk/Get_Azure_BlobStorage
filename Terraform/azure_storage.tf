resource "azurerm_resource_group" "rg" {
  name     = var.ResourceGroupName
  location = var.Location
}

resource "azurerm_storage_account" "sa" {
  name                     = var.StorageAccountName
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "sc" {
  name                  = var.ContainerName
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "sc-4" {
  name                  = "sqlbackup-2"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "azurerm_resource_group" "rg-2" {
  name     = "Azure_SQL_02"
  location = var.Location
}

resource "azurerm_storage_account" "sa-2" {
  name                     = "sqlupworkjana02"
  resource_group_name      = azurerm_resource_group.rg-2.name
  location                 = azurerm_resource_group.rg-2.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "sc-2" {
  name                  = "sqlbackup-3"
  storage_account_name  = azurerm_storage_account.sa-2.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "sc-3" {
  name                  = "sqlbackup-4"
  storage_account_name  = azurerm_storage_account.sa-2.name
  container_access_type = "private"
}

resource "azurerm_resource_group" "rg-3" {
  name     = "Azure_SQL_03"
  location = var.Location
}

resource "azurerm_resource_group" "rg-4" {
  name     = "Azure_SQL_04"
  location = var.Location
}

resource "azurerm_storage_account" "sa-5" {
  name                     = "sqlupworkjana03"
  resource_group_name      = azurerm_resource_group.rg-4.name
  location                 = azurerm_resource_group.rg-4.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_resource_group" "rg-5" {
  name     = "Azure_SQL_05"
  location = var.Location
}

resource "azurerm_storage_account" "sa-6" {
  name                     = "sqlupworkjana04"
  resource_group_name      = azurerm_resource_group.rg-5.name
  location                 = azurerm_resource_group.rg-5.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "sc-6" {
  name                  = "sqlbackup-6"
  storage_account_name  = azurerm_storage_account.sa-6.name
  container_access_type = "private"
}