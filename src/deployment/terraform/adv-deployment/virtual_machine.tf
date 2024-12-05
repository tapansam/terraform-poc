data "azurerm_resource_group" "adv" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "adv" {
  name                = module.naming.virtual_network.name
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.adv.location
  resource_group_name = data.azurerm_resource_group.adv.name
}

resource "azurerm_subnet" "adv" {
  name                 = module.naming.subnet.name
  resource_group_name  = data.azurerm_resource_group.adv.name
  virtual_network_name = azurerm_virtual_network.adv.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "adv" {
  name                = module.naming.network_interface.name
  location            = data.azurerm_resource_group.adv.location
  resource_group_name = data.azurerm_resource_group.adv.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.adv.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "adv" {
  name                = module.naming.linux_virtual_machine.name
  resource_group_name = data.azurerm_resource_group.adv.name
  location            = data.azurerm_resource_group.adv.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.adv.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.main.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
