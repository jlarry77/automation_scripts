#!/bin/bash

# --- 1. Define variables and automatically determine container name ---
VM_MONITOR_DIR="vm_monitor"
DOCKER_COMPOSE_FILE="docker-compose.yml"

# Get the hostname of the server
SERVER_HOSTNAME=$(hostname)

# Construct the container name
CONTAINER_NAME="${SERVER_HOSTNAME}_node_exp"

echo "Good morning! Let's set up your VM monitor."
echo "Determining container name based on hostname: '${SERVER_HOSTNAME}'"
echo "The node_exporter container will be named: '${CONTAINER_NAME}'"

# --- 2. Create directory and navigate into it ---
echo "Creating directory: $VM_MONITOR_DIR"
mkdir -p "$VM_MONITOR_DIR" # -p creates parent directories if they don't exist and doesn't error if dir exists
cd "$VM_MONITOR_DIR" || { echo "Failed to change directory. Exiting."; exit 1; }

# --- 3. Create and populate docker-compose.yml ---
echo "Creating $DOCKER_COMPOSE_FILE with container name: $CONTAINER_NAME"
cat <<EOF > "$DOCKER_COMPOSE_FILE"
services:
  node_exporter:
    image: prom/node-exporter
    container_name: $CONTAINER_NAME
    ports:
      - "9100:9100"
    restart: unless-stopped
EOF

# --- 4. Bring up Docker Compose services ---
echo "Starting Docker services with docker compose up..."
docker compose up -d # -d for detached mode (runs in background)

echo "Setup complete! Node Exporter should be running as '$CONTAINER_NAME' and accessible on port 9100."
echo "You can check its status with: docker ps -f name=$CONTAINER_NAME"
echo "To stop the services, run: docker compose down (from within the vm_monitor directory)"
