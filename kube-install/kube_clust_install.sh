#!/bin/bash

# This script automates the installation of Docker, containerd, and Kubernetes
# components (kubeadm, kubectl, kubelet) on a Linux VM.
# It is designed to be run on each node that will be part of a Kubernetes cluster.

# --- 1. Disable Swap ---
# Kubernetes requires swap to be disabled.
echo "Disabling swap..."
sudo swapoff -a
# Remove swap entry from /etc/fstab to persist across reboots
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
echo "Swap disabled."

# --- 2. Install Docker and containerd ---
# Add Docker's official GPG key
echo "Installing Docker and containerd..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Create directory for Docker's GPG key if it doesn't exist
sudo mkdir -p /etc/apt/keyrings
# Download and add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the stable Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine, containerd, and Docker CLI
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

echo "Docker and containerd installed."

# --- 3. Configure containerd for Kubernetes ---
# Configure containerd to use systemd cgroup driver
echo "Configuring containerd..."
# Create default containerd configuration file
sudo containerd config default | sudo tee /etc/containerd/config.toml > /dev/null

# Modify containerd config to set SystemdCgroup = true
# This is crucial for Kubernetes to work correctly with containerd
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

# Restart containerd to apply the changes
sudo systemctl restart containerd
echo "Containerd configured and restarted."

# --- 4. Add Kubernetes apt repository ---
echo "Adding Kubernetes apt repository..."
# Install packages required for adding Kubernetes repository
sudo apt-get update
sudo apt-get install -y apt-transport-https

# Download and add Kubernetes GPG key
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add Kubernetes apt repository
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null
echo "Kubernetes apt repository added."

# --- 5. Install Kubernetes components ---
echo "Installing kubelet, kubeadm, and kubectl..."
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

# Hold their versions to prevent accidental upgrades that might break the cluster
sudo apt-mark hold kubelet kubeadm kubectl
echo "Kubernetes components installed and versions held."

# --- 6. Enable IP forwarding and bridge-nf-call-iptables ---
# These settings are necessary for Kubernetes networking (e.g., Pod communication)
echo "Enabling IP forwarding and bridge-nf-call-iptables..."
# Load br_netfilter module
sudo modprobe br_netfilter

# Add kernel parameters to sysctl.conf to persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Apply sysctl parameters immediately
sudo sysctl --system
echo "IP forwarding and bridge-nf-call-iptables enabled."

# --- 7. Reload daemon and restart services ---
echo "Reloading daemon and restarting services..."
sudo systemctl daemon-reload
sudo systemctl enable kubelet
sudo systemctl start kubelet
sudo systemctl enable containerd
sudo systemctl start containerd
sudo systemctl enable docker
sudo systemctl start docker
echo "Services reloaded and started."

echo "Kubernetes pre-requisites setup complete!"
echo "You can now use 'kubeadm init' on your control plane node and 'kubeadm join' on worker nodes."
