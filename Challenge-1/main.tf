resource "azurerm_resource_group" "rg" {
  name = "my-test-rg"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name = "my-test-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  address_space = ["10.0.0.0/16"] 
}

resource "azurerm_subnet" "my-web" {
  name = "my-test-web-subnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "my-app" {
  name = "my-test-app-subnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "my-db" {
  name = "my-test-db-subnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.3.0/24"]
  service_endpoints = ["Microsoft.Sql", "Microsoft.Storage"]
}

resource "azurerm_network_interface" "web" {
  name = "my-web-nic"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location

  ip_configuration {
    name = "ip-config"
    subnet_id = azurerm_subnet.my-web.id
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_virtual_machine" "web-vm" {
  name = "my-web-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  vm_size = "Standard_DS1_v2"

  network_interface_ids = [azurerm_network_interface.web.id]

  storage_os_disk {
    name = "os-disk-web"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = var.vm_user
    admin_password = var.vm_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_network_interface" "app-nic" {
  name = "my-app-nic"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location

  ip_configuration {
    name = "ip-config"
    subnet_id = azurerm_subnet.my-app.id
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_virtual_machine" "app" {
  name = "my-app-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  vm_size = "Standard_B2s"

  network_interface_ids = [azurerm_network_interface.app-nic.id]

  storage_os_disk {
    name = "os-disk-app"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

os_profile {
    computer_name  = "hostname"
    admin_username = var.vm_user
    admin_password = var.vm_password
  }
os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_storage_account" "my-db" {
  name = "mystorageaccount"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
    network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [azurerm_subnet.my-app.id]
  }
}
