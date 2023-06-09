terraform {
  required_version = ">=0.12"
   required_providers {
      azurerm = ">3.0"
   }
}
provider "azurerm" {
   features {}
}

 resource "azurerm_resource_group" "webserver" {
   name = "LAST-Jenkins-Terraformed"
   location = "westeurope"
}

 resource "azurerm_virtual_network" "webserver-net" {
  name                = "webserver-net"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.webserver.location
  resource_group_name = azurerm_resource_group.webserver.name
}

 resource "azurerm_subnet" "webserver-subnet" {
  name                 = "subnet01"
  resource_group_name  = azurerm_resource_group.webserver.name
  virtual_network_name = azurerm_virtual_network.webserver-net.name
  address_prefixes       = ["10.0.1.0/24"]

 }

 resource "azurerm_network_security_group" "allowedports" {
   name = "allowedports"
   resource_group_name = azurerm_resource_group.webserver.name
   location = azurerm_resource_group.webserver.location
  
   security_rule {
       name = "http"
       priority = 100
       direction = "Inbound"
       access = "Allow"
       protocol = "Tcp"
       source_port_range = "*"
       destination_port_range = "80"
       source_address_prefix = "*"
       destination_address_prefix = "*"
   }

   security_rule {
       name = "https"
       priority = 200
       direction = "Inbound"
       access = "Allow"
       protocol = "Tcp"
       source_port_range = "*"
       destination_port_range = "443"
       source_address_prefix = "*"
       destination_address_prefix = "*"
   }

   security_rule {
       name = "ssh"
       priority = 300
       direction = "Inbound"
       access = "Allow"
       protocol = "Tcp"
       source_port_range = "*"
       destination_port_range = "22"
       source_address_prefix = "*"
       destination_address_prefix = "*"
   }

   security_rule {
       name = "8080"
       priority = 1001
       direction = "Inbound"
       access = "Allow"
       protocol = "Tcp"
       source_port_range = "*"
       destination_port_range = "8080"
       source_address_prefix = "*"
       destination_address_prefix = "*"
   }

   security_rule {
       name = "1337"
       priority = 1002
       direction = "Inbound"
       access = "Allow"
       protocol = "Tcp"
       source_port_range = "*"
       destination_port_range = "1337"
       source_address_prefix = "*"
       destination_address_prefix = "*"
   }
}

 resource "azurerm_public_ip" "webserver_public_ip" {
   name = "webserver_public_ip"
   location = azurerm_resource_group.webserver.location
   resource_group_name = azurerm_resource_group.webserver.name
   allocation_method = "Dynamic"

   depends_on = [azurerm_resource_group.webserver]
}

 resource "azurerm_network_interface" "webserver" {
   name = "nginx-interface"
   location = azurerm_resource_group.webserver.location
   resource_group_name = azurerm_resource_group.webserver.name

   ip_configuration {
       name = "internal"
       private_ip_address_allocation = "Dynamic"
       subnet_id = azurerm_subnet.webserver-subnet.id
       public_ip_address_id = azurerm_public_ip.webserver_public_ip.id
   }

   depends_on = [azurerm_resource_group.webserver]
}

 resource "azurerm_linux_virtual_machine" "nginx" {
   size = "Standard_F2"
   name = "VM-Jenkins-TERRA"
   resource_group_name = azurerm_resource_group.webserver.name
   location = azurerm_resource_group.webserver.location
   network_interface_ids = [
       azurerm_network_interface.webserver.id,
   ]

   source_image_reference {
       publisher = "Canonical"
       offer = "UbuntuServer"
       sku = "18.04-LTS"
       version = "latest"
   }

   computer_name = "Jenkins-Terra"
   admin_username = "momo"
   admin_password = "Admin123456"
   disable_password_authentication = false

   os_disk {
       name = "nginxdisk01"
       caching = "ReadWrite"
       storage_account_type = "Standard_LRS"
   }

   depends_on = [azurerm_resource_group.webserver]
}

