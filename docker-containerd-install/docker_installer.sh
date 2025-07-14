#!/bin/bash

# Install Docker and Containerd
# Add Dcoker's GPG Key

echo "Installing Docker and containerd..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Create Docker GPG key directory, if it doesn't already exist
sudo mkdir -p /etc/apt/keyrings

# Download and add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the Stable Docker Repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine, containerd, and Docker CLI
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

echo "Docker and Containerd have been Installed."


