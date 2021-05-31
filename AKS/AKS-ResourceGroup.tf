#-------------------> Resource group for AKS 
resource "azurerm_resource_group" "RG-KUBERNETES" {
  name     = "RG-KUBERNETES"
  location =  var.region

  tags = {
      environment = var.tagprod
  }
}

#-------------------> Resource group for MSSQL 
resource "azurerm_resource_group" "RG-DATABASES" {
  name     = "RG-DATABASES"
  location =  var.region

  tags = {
      environment = var.tagprod
  }
}

#-------------------> Resource group for Azure Container Registry
resource "azurerm_resource_group" "RG-ContainerRegistry" {
  name     = "RG-ContainerRegistry"
  location = var.region

  tags = {
      environment = var.tagprod
  }
}