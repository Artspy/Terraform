#-------------------> Authentication to Microsoft Azure
provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}

#-------------------> Azure AKS cluster
resource "azurerm_kubernetes_cluster" "AKS-Fitverse" {
  name                = "AKS-Fitverse"
  location            = azurerm_resource_group.RG-KUBERNETES.location
  resource_group_name = azurerm_resource_group.RG-KUBERNETES.name
  dns_prefix          = "AKS-Fitverse"

  #Grouping all the internal objects of this cluster
  node_resource_group = "${azurerm_resource_group.RG-KUBERNETES.name}-NODE"

  #Automatically assign ID by azure
  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  #service_principal {
  #  client_id     = var.serviceprinciple_id
  #  client_secret = var.serviceprinciple_key
  #}

  linux_profile {
    admin_username = "fitverse"
    ssh_key {
      key_data = var.ssh_key
    }
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "Basic"
  }

  tags = {
    Environment = var.tagprod
  }
}

#-------------------> Authentication to AKS-Fitverse
provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.AKS-Fitverse.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.AKS-Fitverse.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.AKS-Fitverse.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.AKS-Fitverse.kube_config.0.cluster_ca_certificate)
}

#-------------------> Azure HD-Disk for persistent volume in AKS
resource "azurerm_managed_disk" "HD-PV-AKS" {
  name                 = "HD-PV-AKS"
  location             = azurerm_resource_group.RG-KUBERNETES.location
  resource_group_name  = azurerm_resource_group.RG-KUBERNETES.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "5"

  tags = {
    environment = var.tagprod
  }
}

#-------------------> Azure Container Registry for AKS
resource "azurerm_container_registry" "CRFitverse" {
  name                = "CRFitverse"
  resource_group_name = azurerm_resource_group.RG-ContainerRegistry.name
  location            = azurerm_resource_group.RG-ContainerRegistry.location
  sku                 = "Standard"
  admin_enabled       = false

  tags = {
    Environment = var.tagprod
  }
}

#-------------------> Adding the role to the identity the AKS cluster was assigned
resource "azurerm_role_assignment" "AKSFitverse_CRFitverse" {
  scope                = azurerm_container_registry.CRFitverse.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.AKS-Fitverse.kubelet_identity[0].object_id
  depends_on = [
    azurerm_kubernetes_cluster.AKS-Fitverse, azurerm_container_registry.CRFitverse
  ]
}
