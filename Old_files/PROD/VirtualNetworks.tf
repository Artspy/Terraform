#Azure Virtual Network pVN-Main
resource "azurerm_virtual_network" "pVN-Main" {
  name                = "pVN-Main"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.RG-NETWORK.location
  resource_group_name = azurerm_resource_group.RG-NETWORK.name

  tags = {
      environment = var.tagprod
  }
}

#Azure Subnet
resource "azurerm_subnet" "SNET-Main" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.RG-NETWORK.name
  virtual_network_name = azurerm_virtual_network.pVN-Main.name
  address_prefixes     = ["10.0.0.0/24"]

}