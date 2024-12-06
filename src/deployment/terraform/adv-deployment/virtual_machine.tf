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

resource "azurerm_network_security_group" "adv" {
  name                = module.naming.network_security_group.name
  location            = data.azurerm_resource_group.adv.location
  resource_group_name = data.azurerm_resource_group.adv.name
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.adv.name
  network_security_group_name = azurerm_network_security_group.adv.name
}

resource "azurerm_network_security_rule" "http" {
  name                        = "http"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.adv.name
  network_security_group_name = azurerm_network_security_group.adv.name
}

resource "azurerm_network_security_rule" "https" {
  name                        = "https"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.adv.name
  network_security_group_name = azurerm_network_security_group.adv.name
}

resource "azurerm_subnet_network_security_group_association" "adv" {
  subnet_id                 = azurerm_subnet.adv.id
  network_security_group_id = azurerm_network_security_group.adv.id
}

resource "azurerm_public_ip" "adv" {
  name                = module.naming.public_ip.name
  location            = data.azurerm_resource_group.adv.location
  resource_group_name = data.azurerm_resource_group.adv.name
  allocation_method   = "Static"
  sku                 = "Basic"
  ip_version          = "IPv4"
}

resource "azurerm_network_interface" "adv" {
  name                = module.naming.network_interface.name
  location            = data.azurerm_resource_group.adv.location
  resource_group_name = data.azurerm_resource_group.adv.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.adv.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.adv.id
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
