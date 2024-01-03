terraform {
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
      }
    }
    
    ### Specifies an Azure Blob Storage for tfstate
    
    backend "azurerm" {
        resource_group_name  = "" ## Storage Account Resource Group
        storage_account_name = "" ## Storage account name
        container_name       = "terraform" ## container name
        key                  = "terraform.tfstate" ## Key
    }
}

 provider "azurerm" {
   features {}
   skip_provider_registration = true
 }