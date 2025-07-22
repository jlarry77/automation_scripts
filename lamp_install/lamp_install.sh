#!/bin/bash

# - - - Error Handling Function - - -
check_command() {
	if [ $? -ne 0 ]; then
		echo "ERROR: $1 failed.  Exiting."
		exit 1
	fi
}

echo "Beginning LAMP Stack Installation..."

# 1.  Update the System and Install Apache 2
echo "Updating package lists..."
sudo apt update
check_command "apt update"

echo "Installing Apache2..."
sudo apt install apache2 -y
check_command "Apache2 installation"

# 2.  Enable and Start Aapache 2
echo "Enabling and starting Apache2 service..."
sudo systemctl enable apache2.service
check_command "Apache2 enable"
sudo systemctl start apache2.service
check_command "Apache2 start"

echo "Apache 2 Service Status:"
sudo systemctl status apache2.service

# 3.  Install MySQL Server
echo "Installing MariaDB...(recommended replacement for MySQL)..."
sudo apt install mariadb-server -y
check_command "MariaDB installation"

echo "!!! IMPORTANT: Please run 'sudo mysql_secure_installation' manually after this script completes !!!"
echo "This step is interactive and cannot be fully automated without additional tools (e.g., 'expect') or pre-seeding."

# 4.  Install PHP and Depencies
echo "Installing PHP and essential modules..."
sudo apt install php libapache2-mod-php php-mysql -y
check_command "PHP core and Apache module installation."

echo "Installing additional common PHP Modules..."
sudo apt install php-cli php-json php-curl php-gd php-mbstring php-xml -y
check_command "Additional PHP modules installation"

#  Restart the Apache 2 Service
echo "Restarting Apache 2 Service, to apply PHP changes..."
sudo systemctl restart apache2.service
check_command "Apache2 restart"

echo "LAMP stack installation script completed.  Please remember to run 'sudo mysql_secure_installation'."


