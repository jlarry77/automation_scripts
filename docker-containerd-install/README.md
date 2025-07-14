# Docker and Containerd Installation Script for Ubuntu

This script automates the installation of Docker Engine, containerd, and Docker CLI on Ubuntu systems. It handles adding Docker's official GPG key and setting up the stable APT repository, ensuring you get the latest stable versions.

## Features

* Installs necessary prerequisites (`ca-certificates`, `curl`, `gnupg`, `lsb-release`).
* Adds Docker's official GPG key to your system's keyring.
* Configures the stable Docker APT repository.
* Installs `docker-ce`, `docker-ce-cli`, and `containerd.io`.
* Provides instructions for adding your user to the `docker` group to run commands without `sudo`.

## Prerequisites

* An Ubuntu system (tested on 24.04 LTS, but should work on recent LTS versions).
* Internet connectivity.
* `sudo` privileges.

## Usage

1.  **Navigate to the script's directory:**
    ```bash
    cd linux-automation-scripts/docker-containerd-install
    ```
    (Assuming you've cloned the main repository)
2.  **Make the script executable:**
    ```bash
    chmod +x docker_installer.sh
    ```
3.  **Run the script with `sudo`:**
    ```bash
    sudo ./docker_installer.sh
    ```

### Post-Installation Steps

* **Add your user to the `docker` group (Highly Recommended):**
    To run Docker commands without needing `sudo` every time, add your current user to the `docker` group.
    ```bash
    sudo usermod -aG docker $USER
    ```
    * **Important:** You will need to **log out and log back in** (or restart your terminal session) for this change to take effect.
* **Verify Docker Installation:**
    After logging back in, you can verify Docker is working by running the `hello-world` container:
    ```bash
    docker run hello-world
    ```
    You should see a message confirming the installation.
* **Check Docker Service Status:**
    ```bash
    sudo systemctl status docker
    ```

## Troubleshooting

* **"Failed to update APT package index":** Check your internet connection or if apt sources are misconfigured.
* **"Failed to download and add Docker GPG key":** Verify network connectivity and access to `download.docker.com`.
* **Docker commands still require `sudo` after running script:** Ensure you have logged out and logged back in after adding your user to the `docker` group.

---
