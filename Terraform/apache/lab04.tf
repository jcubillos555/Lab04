# Configure the Microsoft Azure Provider
provider "azurerm" {
    version = ">=1.39"  
    subscription_id = var.azure_subscription_id
    tenant_id       = var.azure_tenant_id
}

# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "myterraformgroup" {
    name     = var.azure_resource_group
    location = var.azure_location
}

# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = var.azure_vnet
    address_space       = ["10.0.0.0/16"]
    location = var.azure_location
    resource_group_name = azurerm_resource_group.myterraformgroup.name
}

# Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
    name                 = "mySubnet"
    resource_group_name  = azurerm_resource_group.myterraformgroup.name
    virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
    address_prefix       = "10.0.1.0/24"
}

# Create public IPs
resource "azurerm_public_ip" "myterraformpublicip" {
    name                         = "myPublicIPWeb"
    location                     = var.azure_location
    resource_group_name          = azurerm_resource_group.myterraformgroup.name
    allocation_method            = "Dynamic"
    domain_name_label            = var.azure_dns
}

# Create public IPs
resource "azurerm_public_ip" "myterraformpublicipbd" {
    name                         = "myPublicIPBD"
    location                     = var.azure_location
    resource_group_name          = azurerm_resource_group.myterraformgroup.name
    allocation_method            = "Dynamic"
    domain_name_label            = var.azure_dns_bd
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "myNetworkSecurityGroup"
    location            = var.azure_location
    resource_group_name = azurerm_resource_group.myterraformgroup.name
    
    security_rule {
        name                       = "SSH"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
  
    security_rule {
        name                       = "HTTP"
        priority                   = 1003   
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "TCP"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}


# Create network interface
resource "azurerm_network_interface" "myterraformnic" {
    name                      = "myNICweb"
    location                  = var.azure_location
    resource_group_name       = azurerm_resource_group.myterraformgroup.name
    network_security_group_id = azurerm_network_security_group.myterraformnsg.id

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
    }
}

# Create network interface
resource "azurerm_network_interface" "myterraformnicbd" {
    name                      = "myNICbd"
    location                  = var.azure_location
    resource_group_name       = azurerm_resource_group.myterraformgroup.name
    network_security_group_id = azurerm_network_security_group.myterraformnsg.id

    ip_configuration {
        name                          = "myNicConfigurationbd"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.myterraformpublicipbd.id
    }
} 

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.myterraformgroup.name
    }
    
    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.myterraformgroup.name
    location                    = var.azure_location
    account_tier                = "Standard"
    account_replication_type    = "LRS"
}

# Create virtual machine Apache
resource "azurerm_virtual_machine" "myterraformvm" {
    name                  = "myWeb"
    location              = var.azure_location
    resource_group_name   = azurerm_resource_group.myterraformgroup.name
    network_interface_ids = [azurerm_network_interface.myterraformnic.id]
    vm_size               = var.azure_sizevm

    storage_os_disk {
        name              = "myOsDiskWeb"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "myvmweb"
        admin_username = var.admin_username
        admin_password = var.admin_password
    #    custom_data execute scrip init 
    }

    os_profile_linux_config {
        disable_password_authentication = false
        #ssh_keys {
        #    path     = "/home/azureuser/.ssh/authorized_keys"
        #    key_data = "ssh-rsa AAAAB3Nz{snip}hwhqT9h"
        #}
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }
}
resource "azurerm_virtual_machine_extension" "cs_apache" {
  name = "custom_apache"
  location = var.azure_location
  resource_group_name   = azurerm_resource_group.myterraformgroup.name
  virtual_machine_name  = azurerm_virtual_machine.myterraformvm.name
  publisher = "Microsoft.OSTCExtensions"
  type = "CustomScriptForLinux"
  type_handler_version  = "1.2"

  settings = <<SETTINGS
    {
                "fileUris":
         [
        "https://terraformlab04.blob.core.windows.net/install/apache-php.sh"
         ],
        "commandToExecute": "sh apache-php.sh"
    }
SETTINGS
}
# Create virtual machine Mysql
resource "azurerm_virtual_machine" "myterraformbd" {
    name                  = "mybd"
    location              = var.azure_location
    resource_group_name   = azurerm_resource_group.myterraformgroup.name
    network_interface_ids = [azurerm_network_interface.myterraformnicbd.id]
    vm_size               = var.azure_sizevm

    storage_os_disk {
        name              = "myOsDiskbd"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "mysql"
        admin_username = var.admin_username
        admin_password = var.admin_password
    #    custom_data execute scrip init 
    }

    os_profile_linux_config {
        disable_password_authentication = false
        #ssh_keys {
        #    path     = "/home/azureuser/.ssh/authorized_keys"
        #    key_data = "ssh-rsa AAAAB3Nz{snip}hwhqT9h"
        #}
    }
}
resource "azurerm_virtual_machine_extension" "cs_mysql" {
  name = "custom_mysql"
  location = var.azure_location
  resource_group_name   = azurerm_resource_group.myterraformgroup.name
  virtual_machine_name  = azurerm_virtual_machine.myterraformbd.name
  publisher = "Microsoft.OSTCExtensions"
  type = "CustomScriptForLinux"
  type_handler_version  = "1.2"

  settings = <<SETTINGS
    {
                "fileUris":
         [
        "https://terraformlab04.blob.core.windows.net/mysql/mysql.sh"
         ],
        "commandToExecute": "sh mysql.sh"
    }
SETTINGS
}