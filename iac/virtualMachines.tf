
resource "azurerm_virtual_machine" "frontend" {
  name                  = "frontendVM"
  location              = var.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.frontend.id]
  vm_size               = var.frontend_vm_size

  storage_os_disk {
    name              = "frontendOSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_profile {
    computer_name  = "frontendVM"
    admin_username = var.admin_username

    custom_data = <<EOF

      #cloud-config
      package_update: true
      package_upgrade: true
      packages:
        - docker.io
        - docker-compose
        - git
      runcmd:
        - sudo systemctl start docker
        - sudo systemctl enable docker
        - echo 'export REACT_APP_BACKEND_URL=http://${azurerm_public_ip.AAG_public_ip.ip_address}:3001' >> /etc/environment
        - echo 'export GOOGLE_KEY="${var.google_key}"' >> /etc/environment
        - echo 'export REACT_APP_BACKEND_URL=http://${azurerm_public_ip.AAG_public_ip.ip_address}:3001' >> /etc/profile.d/env.sh
        - echo 'export GOOGLE_KEY="${var.google_key}"' >> /etc/profile.d/env.sh
        - sudo -u azureuser git clone https://github.com/datorresr/tunefy.git /home/azureuser/tunefy
        - cd /home/azureuser/tunefy/frontend
        - docker-compose up -d
      EOF
  }

  os_profile_linux_config {
    disable_password_authentication = true
    

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.pub")
    }
  }
}



resource "azurerm_virtual_machine" "backend" {
  name                  = "backendVM"
  location              = var.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.backend.id]
  vm_size               = var.backend_vm_size

  storage_os_disk {
    name              = "backendOSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_profile {
    computer_name  = "backendVM"
    admin_username = var.admin_username

    custom_data = <<EOF

    #cloud-config
    package_update: true
    package_upgrade: true
    packages:
      - docker.io
      - docker-compose
      - git
    runcmd:
      - sudo systemctl start docker
      - sudo systemctl enable docker
      - echo 'export PGUSER="${var.pguser}"' >> /etc/environment
      - echo 'export PGDATABASE="${var.pgdatabase}"' >> /etc/environment
      - echo 'export PGPASSWORD="${var.pgpassword}"' >> /etc/environment
      - echo 'export AI21_TOKEN="${var.ai21_token}"' >> /etc/environment
      - echo 'export PGHOST="${azurerm_network_interface.database.private_ip_address}"' >> /etc/environment
      - echo 'export PGUSER="${var.pguser}"' >> /etc/profile.d/env.sh
      - echo 'export PGDATABASE="${var.pgdatabase}"' >> /etc/profile.d/env.sh
      - echo 'export PGPASSWORD="${var.pgpassword}"' >> /etc/profile.d/env.sh
      - echo 'export PGHOST="${azurerm_network_interface.database.private_ip_address}"' >> /etc/profile.d/env.sh
      - echo 'export AI21_TOKEN="${var.ai21_token}"' >> /etc/profile.d/env.sh
      - sudo -u azureuser git clone https://github.com/datorresr/tunefy.git /home/azureuser/tunefy
      - cd /home/azureuser/tunefy/backend
      - sudo docker-compose up -d
    EOF
  }

  os_profile_linux_config {
    disable_password_authentication = true
    

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.pub")
   }
  }

  depends_on = [azurerm_network_interface.database]

}


resource "azurerm_virtual_machine" "bastion" {
  name                  = "bastionVM"
  location              = var.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.bastion.id]
  vm_size               = var.bastion_vm_size

  storage_os_disk {
    name              = "bastionOSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_profile {
    computer_name  = "bastionVM"
    admin_username = var.admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = true
    

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.pub")
   }
  }
}

/*
resource "azurerm_virtual_machine" "gitlab_runner" {
  name                  = "gitlabRunnerVM"
  location              = var.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.gitlab_runner.id]
  vm_size               = var.gitlab_runner_vm_size

  storage_os_disk {
    name              = "gitlabRunnerOSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_profile {
    computer_name  = "gitlabRunnerVM"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = true
    

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.pub")
    }
  }
}
*/