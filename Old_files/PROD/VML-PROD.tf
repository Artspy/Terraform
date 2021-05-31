#-------------------> Azure Virtual Machine PROD01
resource "azurerm_linux_virtual_machine" "pVML-APP01" {
  name                = "${var.env}VML-APP01"
  resource_group_name = azurerm_resource_group.RG-PROD.name
  location            = azurerm_resource_group.RG-PROD.location
  size                = "Standard_B1s"
  admin_username      = "fitverse"
  disable_password_authentication = true
  computer_name       = "${var.env}VML-APP01" 
  network_interface_ids  = [
    azurerm_network_interface.NIC-VML-APP01.id,
  ]

  admin_ssh_key {
    username      = "fitverse"
    public_key    = var.ssh-fitverse  
    }

  os_disk {
    caching               = "ReadWrite"
    storage_account_type  = "Standard_LRS"
	  disk_size_gb          = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = {
      environment = var.tagprod
  }
}

#-------------------> Azure Network Interface pVML-APP01
resource "azurerm_network_interface" "NIC-VML-APP01" {
  name                = "NIC-VML-APP01"
  location            = azurerm_resource_group.RG-PROD.location
  resource_group_name = azurerm_resource_group.RG-PROD.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SNET-Main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pVML-Public_IP-APP01.id 
  }

  tags = {
      environment = var.tagprod
  }
}

#-------------------> Azure Public IP for Virtual Machine PROD01
resource "azurerm_public_ip" "pVML-Public_IP-APP01" {
  name                = "${var.env}VML-Public_IP-APP01"
  resource_group_name = azurerm_resource_group.RG-PROD.name
  location            = azurerm_resource_group.RG-PROD.location
  allocation_method   = "Static"
  domain_name_label   = "pvml-app01"

  tags = {
    environment = var.tagprod
  }
}


#-------------------> Azure Virtual Machine PROD02
  resource "azurerm_linux_virtual_machine" "pVML-APP02" {
  name                = "${var.env}VML-APP02"
  resource_group_name = azurerm_resource_group.RG-PROD.name
  location            = azurerm_resource_group.RG-PROD.location
  size                = "Standard_B1s"
  admin_username      = "fitverse"
  disable_password_authentication = true
  computer_name = "${var.env}VML-APP02" 
  network_interface_ids = [
    azurerm_network_interface.NIC-VML-APP02.id,
  ]

  admin_ssh_key {
    username      = "fitverse"
    public_key    = var.ssh-fitverse
  }

  os_disk {
    caching               = "ReadWrite"
    storage_account_type  = "Standard_LRS"
	  disk_size_gb          = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = {
      environment = var.tagprod
  }
}

#-------------------> Azure Network Interface pVML-APP02
resource "azurerm_network_interface" "NIC-VML-APP02" {
  name                = "NIC-VML-APP02"
  location            = azurerm_resource_group.RG-PROD.location
  resource_group_name = azurerm_resource_group.RG-PROD.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SNET-Main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pVML-Public_IP-APP02.id 
  }

  tags = {
      environment = var.tagprod
  }
}

#-------------------> Azure Public IP for Virtual Machine PROD02
resource "azurerm_public_ip" "pVML-Public_IP-APP02" {
  name                = "${var.env}VML-Public_IP-APP02"
  resource_group_name = azurerm_resource_group.RG-PROD.name
  location            = azurerm_resource_group.RG-PROD.location
  allocation_method   = "Static"
  domain_name_label   = "pvml-app02"

  tags = {
    environment = var.tagprod
  }
}