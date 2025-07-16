# Linux Automation Scripts
![Ubuntu](https://img.shields.io/badge/OS-Ubuntu-E95420?logo=ubuntu&logoColor=white)
![Bash](https://img.shields.io/badge/Scripting-Bash-4EAA25?logo=gnubash&logoColor=white)


This repository contains a collection of shell scripts designed to automate common administrative tasks, software installations, and infrastructure setup on Linux systems, primarily focusing on Ubuntu distributions.

## Why This Repository?

As a DevOps enthusiast and system administrator, I often find myself repeating installation and configuration steps. These scripts are developed to streamline these processes, reduce manual errors, and serve as reusable components for various projects and personal labs.

## Contents

Each subdirectory within this repository contains a specific script or a set of related scripts, along with its own detailed `README.md` file explaining its purpose, usage, and any prerequisites.

Here's a quick overview of the currently available scripts:

* **`docker-containerd-install/`**: Automates the installation of Docker Engine, containerd, and Docker CLI on Ubuntu systems.
* **`kube-install/`**: Provides a comprehensive script to set up a Linux VM as a node ready for a Kubernetes cluster, including Docker, containerd, kubeadm, kubectl, and kubelet.
* **`prometheus-monitor/`**: Deploys a Prometheus Node Exporter using Docker Compose to enable basic monitoring of your VM.
* **`tailscale-ubuntu-install/`**: Automates the complete installation of Tailscale on Ubuntu (specifically tested for 24.04 LTS Noble Numbat), including adding repositories, GPG keys, and initial `tailscale up` configuration.

## How to Use

To use any of the scripts:

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/jlarry77/automation-scripts.git](https://github.com/jlarry77/automation-scripts.git)
    cd linux-automation-scripts
    ```
2.  **Navigate to the desired script's directory:**
    ```bash
    cd docker-containerd-install/
    # or
    cd kube-install/
    # etc.
    ```
3.  **Read the specific `README.md` for detailed instructions:**
    ```bash
    cat README.md
    ```
4.  **Execute the script (e.g., for Docker):**
    ```bash
    ./docker_installer.sh
    ```
    * **Caution**: Always review the script's contents before running it, especially those that require `sudo` privileges, to understand exactly what they do.

## Contribution & Feedback

While these scripts are primarily for my personal use and showcase, I welcome feedback, suggestions, or bug reports. If you find an issue or have an improvement, please open an issue or pull request on GitHub.

## License

---
*Created by Justyn Larry / github.com/jlarry77
