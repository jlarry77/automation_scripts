# Prometheus Node Exporter Docker Installation Script

This script automates the deployment of a Prometheus Node Exporter container using Docker Compose. The Node Exporter collects system-level metrics (CPU, memory, disk I/O, network stats, etc.) from the VM it's running on, making them available for Prometheus to scrape. This is a quick way to get basic monitoring set up for a single VM.

## Features

* Automatically determines the container name based on the VM's hostname, ensuring unique identification in a Prometheus setup.
* Creates a dedicated directory (`vm_monitor`) for the Docker Compose configuration.
* Generates a `docker-compose.yml` file to run the `prom/node-exporter` image.
* Maps port `9100` from the host to the container for metric collection.
* Starts the Node Exporter in detached mode (`-d`) using `docker compose up`.
* Includes instructions on how to check the status and stop the container.

## Prerequisites

* **Docker and Docker Compose:** This script assumes Docker Engine and Docker Compose are already installed on your Ubuntu VM. If not, consider using the `docker-containerd-install/docker_installer.sh` script first.
* Internet connectivity to pull the Docker image.
* `sudo` privileges (if your user is not in the `docker` group).

## Usage

1.  **Navigate to the script's directory:**
    ```bash
    cd linux-automation-scripts/prometheus-monitor
    ```
    (Assuming you've cloned the main repository)
2.  **Make the script executable:**
    ```bash
    chmod +x prom_monitor_install.sh
    ```
3.  **Run the script:**
    ```bash
    ./prom_monitor_install.sh
    ```
    (You might need `sudo` if your user is not in the `docker` group)

### Post-Installation Steps

* **Verify Node Exporter Status:**
    ```bash
    docker ps -f name=$(hostname)_node_exp
    ```
    You should see the `node_exporter` container running.
* **Access Metrics:**
    Open your web browser and navigate to `http://<YourVMIP>:9100/metrics`. You should see a page displaying various system metrics.
* **Configure Prometheus:**
    To actually collect these metrics, you will need a running Prometheus server configured to scrape this target. Add the following to your `prometheus.yml` configuration:
    ```yaml
    - job_name: 'node_exporter'
      static_configs:
        - targets: ['<YourVMIP>:9100']
          labels:
            instance: '<YourVMHostname>' # The hostname of this VM
    ```
    Replace `<YourVMIP>` and `<YourVMHostname>` with the actual values.

## Managing the Node Exporter Container

To manage the Node Exporter, navigate into the created `vm_monitor` directory:

```bash
cd vm_monitor
