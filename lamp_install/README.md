LAMP Stack Installation Script
This Bash script automates the installation of a Linux, Apache, MariaDB (as a MySQL replacement), and PHP stack on Debian-based Linux distributions (like Ubuntu).

Features
Automated Installation: Installs Apache2, MariaDB-server, PHP, and essential PHP modules.

Error Handling: Includes checks to ensure each step completes successfully, exiting if an error occurs.

Service Management: Enables and starts Apache2 automatically.

Prerequisites
A Debian-based Linux distribution (e.g., Ubuntu, Debian).

sudo privileges.

An active internet connection to download packages.

How to Use
Save the script:
Save the script content to a file, for example, install_lamp.sh.

Bash

#!/bin/bash

# - - - Error Handling Function - - -
check_command() {
        if [ $? -ne 0 ]; then
            echo "ERROR: $1 failed. Exiting."
            exit 1
        fi
}

echo "Beginning LAMP Stack Installation..."

# 1. Update the System and Install Apache 2
echo "Updating package lists..."
sudo apt update
check_command "apt update"

echo "Installing Apache2..."
sudo apt install apache2 -y
check_command "Apache2 installation"

# 2. Enable and Start Apache 2
echo "Enabling and starting Apache2 service..."
sudo systemctl enable apache2.service
check_command "Apache2 enable"
sudo systemctl start apache2.service
check_command "Apache2 start"

echo "Apache Service Status:"
sudo systemctl status apache2.service

# 3. Install MySQL Server (MariaDB recommended as a drop-in replacement)
echo "Installing MariaDB Server (recommended replacement for MySQL)..."
sudo apt install mariadb-server -y
check_command "MariaDB installation"

echo "!!! IMPORTANT: Please run 'sudo mysql_secure_installation' manually after this script completes !!!"
echo "This step is interactive and cannot be fully automated without additional tools (e.g., 'expect') or pre-seeding."

# 4. Install PHP and Dependencies
echo "Installing PHP and essential modules..."
sudo apt install php libapache2-mod-php php-mysql -y
check_command "PHP core and Apache module installation."

echo "Installing additional common PHP Modules..."
sudo apt install php-cli php-json php-curl php-gd php-mbstring php-xml -y
check_command "Additional PHP modules installation"

# Restart the Apache 2 Service
echo "Restarting Apache2 service, to apply PHP changes..."
sudo systemctl restart apache2.service
check_command "Apache2 restart"

echo "LAMP stack installation script completed. Please remember to run 'sudo mysql_secure_installation'."
Make the script executable:

Bash

chmod +x install_lamp.sh
Run the script:

Bash

sudo ./install_lamp.sh
The script will output its progress and any errors.

Post-Installation Steps (Important!)
After the script completes, you must manually secure your MariaDB installation:

Bash

sudo mysql_secure_installation
This interactive command will guide you through setting a root password, removing anonymous users, disallowing remote root login, and removing the test database. Follow the prompts carefully.

Verification
After the script runs and you've secured MariaDB:

Check Apache: Open your web browser and navigate to http://localhost/ (or your server's IP address). You should see the default Apache "It works!" page.

Check PHP: Create a test PHP file in your web root (/var/www/html/):

Bash

sudo nano /var/www/html/info.php
Add the following content:

PHP

<?php
phpinfo();
?>
Save and exit (Ctrl+X, Y, Enter for nano). Then, in your browser, go to http://localhost/info.php. You should see the PHP information page. Remember to delete info.php after verification for security reasons.
