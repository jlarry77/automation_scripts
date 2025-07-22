# Kubernetes Cluster Node Setup Script

This script automates the essential steps to prepare a Linux VM to be part of a Kubernetes cluster. It installs Docker, containerd, and the core Kubernetes components (`kubeadm`, `kubectl`, `kubelet`), and configures necessary kernel parameters. This script should be run on *every node* (control plane and worker) you intend to add to your Kubernetes cluster.

## Features

* **Disables Swap:** Crucial for Kubernetes stability.
* **Installs Docker & Containerd:** Sets up the container runtime.
* **Configures Containerd:** Ensures it uses the `systemd` cgroup driver, as required by Kubernetes.
* **Adds Kubernetes APT Repository & GPG Key:** Configures your system to download Kubernetes components from official sources.
* **Installs Kubelet, Kubeadm, & Kubectl:** The core tools for cluster management and node operation.
* **Holds Package Versions:** Prevents accidental upgrades of Kubernetes components that could break the cluster.
* **Enables IP Forwarding & Bridge-nf-call-iptables:** Necessary kernel parameters for Kubernetes networking (Pod-to-Pod communication).
* Enables and starts essential services (`containerd`, `docker`, `kubelet`).

## Prerequisites

* A fresh or existing Ubuntu 22.04 LTS+ installation.
* Internet connectivity.
* `sudo` privileges.
* **Important:** This script prepares the node. It does *not* initialize the Kubernetes cluster (`kubeadm init`) or join worker nodes (`kubeadm join`). These are separate steps you will perform manually or with additional scripts after running this one on all desired nodes.

## Usage

1.  **Navigate to the script's directory:**
    ```bash
    cd linux-automation-scripts/kube-install
    ```
    (Assuming you've cloned the main repository)
2.  **Make the script executable:**
    ```bash
    chmod +x kube_clust_install.sh
    ```
3.  **Run the script with `sudo`:**
    ```bash
    sudo ./kube_clust_install.sh
    ```

### Post-Installation Steps

After successfully running this script on all your desired control plane and worker nodes:

1.  **On your designated Control Plane node:**
    Initialize the Kubernetes cluster.
    ```bash
    sudo kubeadm init --pod-network-cidr=<YOUR_POD_CIDR_BLOCK>
    ```
    * Replace `<YOUR_POD_CIDR_BLOCK>` with the CIDR range for your pod network (e.g., `10.244.0.0/16` for Flannel, or `192.168.0.0/16` for Calico, check your CNI's requirements).
    * Follow the on-screen instructions to set up `kubectl` for your non-root user (usually involves copying files from `/etc/kubernetes/admin.conf`).
    * Note the `kubeadm join` command provided at the end of the `kubeadm init` output; you'll use this for your worker nodes.

2.  **Install a Pod Network Add-on (CNI - Container Network Interface) on the Control Plane node:**
    This is critical for Pod-to-Pod communication. Examples:
    * **Flannel:**
        ```bash
        kubectl apply -f [https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml](https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml)
        ```
    * **Calico:** Refer to Calico's official documentation for the latest installation manifest.

3.  **On your designated Worker Nodes:**
    Use the `kubeadm join` command obtained from the `kubeadm init` output on your control plane node.
    ```bash
    sudo kubeadm join <control-plane-ip>:<control-plane-port> --token <token> --discovery-token-ca-cert-hash sha256:<hash>
    ```

4.  **Verify Cluster Status (from Control Plane node):**
    ```bash
    kubectl get nodes
    kubectl get pods -A
    ```

## Troubleshooting

* **"Swap still enabled" error during `kubeadm init`:** Ensure the swap has been disabled and the entry removed from `/etc/fstab` as per the script. A reboot might be necessary if swap was active during script execution.
* **"Failed to pull images" during `kubeadm init`:** Check internet connectivity and ensure Docker and containerd are running correctly (`sudo systemctl status docker containerd`).
* **Nodes not joining:** Verify the `kubeadm join` command's token and hash are correct and have not expired. Check network connectivity between control plane and worker nodes.
* **Pods stuck in `Pending` or `ContainerCreating`:** This often indicates an issue with the CNI (Pod Network Add-on) or `containerd` configuration. Double-check `SystemdCgroup = true` in `/etc/containerd/config.toml` and ensure the CNI is correctly installed.

---
