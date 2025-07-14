# Tailscale Installation Script for Ubuntu

This script automates the full installation of Tailscale on Ubuntu (specifically for Noble Numbat 24.04 LTS, but adaptable for other recent Ubuntu versions). It handles adding the necessary GPG keys, setting up the APT repository, installing the `tailscale` package, and initiating the `tailscale up` command for initial authentication.

## Features

* Automates the download and execution of the official Tailscale `install.sh` script.
* Explicitly adds the Tailscale GPG key and APT repository for Ubuntu 24.04 LTS to ensure correctness.
* Updates the APT package index.
* Installs the `tailscale` package.
* Initiates `tailscale up` for browser-based authentication.
* Attempts to enable Tailscale SSH functionality.

## Prerequisites

* A fresh or existing Ubuntu 24.04 LTS (Noble Numbat) installation.
* Internet connectivity to download packages and scripts.
* `sudo` privileges.

## Usage

1.  **Navigate to the script's directory:**
    ```bash
    cd linux-automation-scripts/tailscale-ubuntu-install
    ```
    (Assuming you've cloned the main repository)
2.  **Make the script executable:**
    ```bash
    chmod +x tailscale_install.sh
    ```
3.  **Run the script with `sudo`:**
    ```bash
    sudo ./tailscale_install.sh
    ```

### Post-Installation Steps

* **Browser Authentication:** After the script runs, a web browser should open (or instructions to open one will be displayed) for you to authenticate your device with your Tailscale account. This step is mandatory for the device to connect to your tailnet.
* **Verify Status:** You can check the Tailscale status using:
    ```bash
    tailscale status
    ```
* **Tailscale SSH:** If `tailscale up --ssh` fails during the script execution (e.g., if the device isn't authenticated yet or if there's a policy issue), you might need to run it manually after successful authentication:
    ```bash
    sudo tailscale up --ssh
    ```
    Ensure Tailscale SSH is enabled in your tailnet policy within the Tailscale admin console.

## Customization

* **Auth Key Automation:** If you want to fully automate `tailscale up` without manual browser authentication, you can modify the script to use an authentication key:
    ```bash
    # In tailscale_install.sh, replace the existing 'sudo tailscale up' line with:
    # sudo tailscale up --authkey tskey-xxxxxxxxxxxx
    ```
    (Replace `tskey-xxxxxxxxxxxx` with an actual ephemeral or reusable auth key from your Tailscale admin console). Be cautious with hardcoding keys in production environments.

## Troubleshooting

* **"Failed to run install.sh":** Check your internet connection.
* **"Failed to add GPG key/APT repository":** Verify the `curl` commands work manually and ensure no firewall is blocking access to `pkgs.tailscale.com`.
* **"'tailscale up' command failed":** Ensure your network is working, and you have active internet. If the browser doesn't open, copy the URL provided by `tailscale up` and open it manually in a browser.

---
