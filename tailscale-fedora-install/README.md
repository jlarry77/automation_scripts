# Tailscale Installation Script for Fedora (Versions 41+)
This repository contains a simple Bash script to automate the installation and initial setup of Tailscale on Fedora Linux, specifically designed for Fedora Version 41 and later.

# Table of Contents
Description

Prerequisites

Usage

Script Breakdown

Troubleshooting

Verification

License

# Description
Tailscale is a mesh VPN that makes connecting your devices and services easy and secure, no matter where they are. This script streamlines the process of getting Tailscale up and running on your Fedora machine by:

Adding the official Tailscale DNF repository.

Installing the tailscale package.

Enabling and starting the tailscaled system service.

Bringing up the Tailscale connection, which initiates browser-based authentication.

Optionally enabling Tailscale SSH functionality.

# Prerequisites
Before running this script, ensure you have:

Fedora Linux (Version 41 or later): This script is tailored for the dnf5 package manager syntax used in newer Fedora releases.

sudo privileges: The script requires root permissions for package installation and service management.

Internet connection: To download packages and connect to the Tailscale service.

A Tailscale account: You'll need an account to authenticate your device. Sign up at tailscale.com.

# Usage
Follow these steps to use the script:

Save the script:
Save the script content to a file, for example, install_tailscale.sh.

```
#!/bin/bash

# This script automates the installation of Tailscale on Fedora (specifically for Fedora Version 41 and Later).

echo "Starting Tailscale installation..."

# --- 1. Add the official Tailscale repository ---
# This step adds the Tailscale DNF repository to your system, using the syntax for Fedora 41+ (dnf5).
echo "Adding Tailscale's official DNF repository..."
if ! sudo dnf config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo; then
    echo "Error: Failed to add Tailscale DNF repository. Exiting."
    exit 1
fi
echo "Tailscale DNF repository added."

# --- 2. Install Tailscale package ---
echo "Installing Tailscale package..."
if ! sudo dnf install -y tailscale; then
    echo "Error: Failed to install Tailscale package. Exiting."
    exit 1
fi
echo "Tailscale package installed."

# --- 3. Use Systemctl to enable and start the Tailscale service.
echo "Starting Tailscale Service..."
if ! sudo systemctl enable --now tailscaled; then
	echo "Error: Failed to start Tailscale Service. Exiting."
	exit 1
fi
echo "Tailscale service enabled and started."

# --- 4. Bring up Tailscale and authenticate ---
echo "Bringing up Tailscale. This will likely open a browser for authentication."
echo "Please follow the instructions in your web browser to authenticate this device."
# The 'tailscale up' command starts the Tailscale service and requires authentication.
# For automation, if you have a pre-authentication key, you can use:
# sudo tailscale up --authkey tskey-xxxxxxxxxxxx
# Otherwise, manual browser authentication is required.
if ! sudo tailscale up; then
    echo "Error: 'tailscale up' command failed. Please check your network connection and Tailscale status."
    exit 1
fi
echo "Tailscale is now trying to connect. Please complete the authentication in your browser."

# --- 5. Enable Tailscale SSH ---
echo "Enabling Tailscale SSH functionality..."
# This command enables Tailscale SSH on the node after it's connected to your tailnet.
if ! sudo tailscale up --ssh; then
    echo "Error: Failed to enable Tailscale SSH. Check your tailnet policy."
    # This might fail if the device isn't authenticated yet or if there's a policy issue.
fi
echo "Tailscale SSH command issued. Check your Tailscale admin console for SSH configuration."

echo "Tailscale installation and initial setup complete!"
echo "Please ensure you have completed the browser-based authentication for 'tailscale up'."
echo "You can check Tailscale status with: tailscale status"
```
# Make the script executable:
Open your terminal and navigate to the directory where you saved the script. Then, run:
```

chmod +x install_tailscale.sh
```
Run the script:
Execute the script using sudo:
```

sudo ./install_tailscale.sh
```

The script will guide you through the process. When it reaches the "Bringing up Tailscale" step, it will provide a URL. You will need to open this URL in a web browser (on the same machine or another device if you're installing on a headless server) to authenticate your device with your Tailscale account.

# Script Breakdown
Here's a step-by-step explanation of what the script does:

1. Add the official Tailscale repository:

```

sudo dnf config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo
```

This command adds the official Tailscale DNF repository to your system's package manager configuration. This ensures that dnf can find and install the Tailscale package. The --from-repofile argument is specifically used for dnf5 (Fedora 41+) to add a repository from a .repo file URL.

2. Install Tailscale package:
```

sudo dnf install -y tailscale
```
This command installs the tailscale package from the newly added repository. The -y flag automatically confirms any prompts during the installation.

3. Use Systemctl to enable and start the Tailscale service:
```

sudo systemctl enable --now tailscaled
```
This command performs two actions:

```enable tailscaled:``` Configures the tailscaled service to start automatically on boot.

```--now:``` Immediately starts the tailscaled service for the current session.

4. Bring up Tailscale and authenticate:
```

sudo tailscale up
```
This is the crucial step for connecting your device to your Tailscale network (your "tailnet"). When run, it will output a URL to the console. You must open this URL in a web browser and log in with your Tailscale account to authenticate the device. Once authenticated, your device will appear in your Tailscale admin console.

Note: If you have an authentication key (e.g., for automated deployments), you can use sudo tailscale up --authkey tskey-xxxxxxxxxxxx instead.

5. Enable Tailscale SSH:
```

sudo tailscale up --ssh
```
This command enables Tailscale's built-in SSH functionality on the current node. This allows you to use Tailscale for secure SSH access to other devices on your tailnet, managed directly through your Tailscale admin console policy. This step might fail if the device isn't fully authenticated yet or if there are specific Tailscale network policies preventing it.

Troubleshooting
"Error: Failed to add Tailscale DNF repository."

Check your internet connection.

Verify the URL https://pkgs.tailscale.com/stable/fedora/tailscale.repo is accessible in a web browser.

Ensure you are running Fedora 41 or later. If you are on an older Fedora version, the dnf config-manager syntax might be different.

"Error: Failed to install Tailscale package."

Ensure the repository was added successfully (check sudo dnf repolist).

Check for any other dnf errors or dependency issues.

tailscale up doesn't open a browser or hangs:

The script explicitly states that it will likely open a browser. If it's a headless server or a desktop environment without a default browser configured, it might just print the URL. Manually copy the provided URL and paste it into a web browser on any device to complete the authentication.

Check your network connection.

"Error: Failed to enable Tailscale SSH."

Ensure your device is fully authenticated and connected to your tailnet.

Verify your Tailscale network's access control policies (ACLs) in the Tailscale admin console to ensure SSH is permitted for this device.

Verification
After the script completes and you've authenticated in your browser, you can verify the installation and connection status:

Check Tailscale status:
```

tailscale status
```
This command will show you the connection status, your Tailscale IP address, and other devices on your tailnet.

Check Tailscale IP address:
```

tailscale ip -4
```
This will display your device's Tailscale IPv4 address.

License
This script is provided under the MIT License. You are free to use, modify, and distribute it.
