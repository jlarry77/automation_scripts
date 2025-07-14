#!/bin/bash

# This script automates the installation of Tailscale on Ubuntu (specifically for Noble Numbat 24.04 LTS).

echo "Starting Tailscale installation..."

# --- 1. Run the official Tailscale install script ---
# This script typically handles adding the repository and GPG key for your OS.
echo "Running Tailscale's official install.sh script..."
if ! curl -fsSL https://tailscale.com/install.sh | sh; then
    echo "Error: Failed to run tailscale.com/install.sh. Exiting."
    exit 1
fi
echo "Official install.sh script executed."

# --- 2. Explicitly add Tailscale GPG key for Noble (Ubuntu 24.04 LTS) ---
# This step ensures the GPG key is correctly placed, overriding or confirming if install.sh did it.
echo "Adding Tailscale GPG key for Ubuntu Noble..."
if ! curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null; then
    echo "Error: Failed to add Tailscale GPG key. Exiting."
    exit 1
fi
echo "Tailscale GPG key added."

# --- 3. Explicitly add Tailscale APT repository list for Noble ---
# This step ensures the APT repository is correctly configured.
echo "Adding Tailscale APT repository list for Ubuntu Noble..."
if ! curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list >/dev/null; then
    echo "Error: Failed to add Tailscale APT repository. Exiting."
    exit 1
fi
echo "Tailscale APT repository added."

# --- 4. Update APT package index ---
echo "Updating APT package index..."
if ! sudo apt-get update; then
    echo "Error: Failed to update APT package index. Exiting."
    exit 1
fi
echo "APT package index updated."

# --- 5. Install Tailscale package ---
echo "Installing Tailscale package..."
if ! sudo apt-get install -y tailscale; then
    echo "Error: Failed to install Tailscale package. Exiting."
    exit 1
fi
echo "Tailscale package installed."

# --- 6. Bring up Tailscale and authenticate ---
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

# --- 7. Enable Tailscale SSH ---
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
