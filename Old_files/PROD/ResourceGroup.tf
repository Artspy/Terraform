#-------------------> Azure RG Production
resource "azurerm_resource_group" "RG-PROD" {
  name     = "RG-PROD"
  location =  var.region

  tags = {
      environment = var.tagprod
  }
}

#-------------------> Azure RG Network
resource "azurerm_resource_group" "RG-NETWORK" {
  name     = "RG-NETWORK"
  location =  var.region

  tags = {
      environment = var.tagprod
  }
}