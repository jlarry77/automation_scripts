Port Scanner Script
This Bash script provides a simple way to scan a range of IP addresses on your local network for a specific open TCP port using nmap. It's designed for quick checks and basic network reconnaissance within your local environment.

Table of Contents
Features

Prerequisites

Usage

Output

Important Notes

Features
Interactive Input: Prompts the user for the starting IP address, the last octet of the ending IP address, and the target port number.

IP Range Scanning: Scans a user-defined range of IP addresses.

Specific Port Scan: Focuses the nmap scan on a single, user-specified TCP port.

Output Management: Saves the raw nmap output and a filtered list of open ports to timestamped files.

Real-time Display: Shows the detected open ports directly in the terminal.

Prerequisites
Before running this script, ensure you have nmap installed on your system.

For Debian/Ubuntu-based systems:

sudo apt update
sudo apt install nmap

For Red Hat/CentOS-based systems:

sudo yum install nmap
# Or for newer Fedora/RHEL versions:
sudo dnf install nmap

Usage
Save the script:
Save the provided script (e.g., port_scanner.sh) to a file.

Make it executable:

chmod +x port_scanner.sh

Run the script:

./port_scanner.sh

The script will then prompt you for the following information:

Starting IP address: E.g., 192.168.1.1

Last octet of the last IP address: E.g., 254 (if you want to scan 192.168.1.1 to 192.168.1.254)

Port Number: E.g., 3306 (for MySQL) or 80 (for HTTP)

Example Walkthrough
$ ./port_scanner.sh
Enter the starting IP address (e.g., 192.168.1.1): 192.168.1.1
Enter the last octet of the ending IP address (e.g., 254): 10
Enter the Port Number you want to scan for (e.g., 80, 22, 3306): 22

Scanning 192.168.1.1-10 for open port 22...
This may take a moment.

Open Ports:
Host: 192.168.1.1 (host.example.com) (Status: Up) Ports: 22/open/tcp//ssh///
Host: 192.168.1.5 (anotherhost) (Status: Up) Ports: 22/open/tcp//ssh///

--------------------------------------------------------------------------------
Raw Nmap output saved to: /tmp/port_scans/PortScan-Raw-07-14-2025_12:30:00
Open ports list saved to: /tmp/port_scans/PortScan-Open-07-14-2025_12:30:00
--------------------------------------------------------------------------------

Output
The script generates two files in a directory named port_scans (by default in /tmp/port_scans, but you can change OUTPUT_DIR in the script):

Raw Nmap Output: Named PortScan-Raw-MM-DD-YYYY_HH:MM:SS. This file contains the complete nmap "grepable" output for the scan.

Open Ports List: Named PortScan-Open-MM-DD-YYYY_HH:MM:SS. This file contains only the lines from the raw output that indicate an "open" port.

Both filenames include a timestamp for easy identification. The script also prints the detected open ports directly to your terminal.

Important Notes
Ethical Use: This script is intended for legitimate network scanning on networks you own or have explicit permission to scan. Unauthorized scanning of networks is illegal and unethical.

Local Network Focus: This script is primarily designed for scanning local IP ranges.

Firewall Considerations: Firewalls can block nmap scans or hide open ports.

Permissions: nmap may require sudo privileges for certain scan types or if it needs to access raw sockets. However, for -sT (TCP connect scan), it often runs without sudo. If you encounter permission errors, try running the script with sudo.
