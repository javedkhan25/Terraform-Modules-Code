terraform {

  backend "azurerm" {

    resource_group_name = "rg-tfstate-prod"

    storage_account_name = "sttfstateprod252757"

    container_name = "tfstate"

    key = "prod.terraform.tfstate"
  }
}