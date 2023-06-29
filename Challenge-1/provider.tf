provider "azurerm" {
  features {}
  skip_provider_registration = true
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tf-state-demo"
    storage_account_name = "sttfstatedemo"
    container_name       = "state"
    key                  = "L8KX7oxSL7lNKOxafeuxcFBfphw+Rf5I5fIKJpzB58ILlDhE65mIyTZXlGB05s/ZngBiEe4c68NB+AStSit7rQ=="
  }
}