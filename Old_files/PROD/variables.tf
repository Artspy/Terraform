provider "azurerm"{
    subscription_id     = var.subscription_id
    client_id           = var.client_id
    client_secret       = var.client_secret
    tenant_id           = var.tenant_id
    features {}
}

//variable subID in Azure 
variable "subscription_id" {
    description = "Enter Subscription ID for provisioning resources in Azure"
}

//variable clientID in Azure
variable "client_id" {
    description = "Enter Client ID for Application created in Azure AD"
}

//variable clientSecret in Azure
variable "client_secret" {
    description = "Enter Client secret for Application in Azure AD"
}

//variable tenantID in Azure
variable "tenant_id" {
    description = "Enter Tenant ID / Directory ID of your Azure AD. Run Get-AzureSubscription"
}

//variable region
variable "region" {
  description = "North Europe"
  default     = "northeurope"
}

//variable to the naming convention  ne
variable "ne" {
  description = "North Europe"
  default     = "ne"
}

//variable environment
variable "env" {
  description = "p like prod"
  default     = "p" //prod environment
}

// resource - hard disk
variable "hd" {
  description = "HD - Hard Drive"
  default     = "HD" 
}

// resource - network interface controller
variable "nic" {
  description = "NIC - Network Interface Controller"
  default     = "NIC" 
}
	
// IP
variable "ip" {
  description = "IP"
  default     = "IP" 
}

// SSH fitverse
variable "ssh-fitverse" {
  description = "Public key SSH for user aspychalla@edu.cdv.pl"
}

// Tag Production
variable "tagprod" {
  description = "Tag Production"
  default = "Production"
}