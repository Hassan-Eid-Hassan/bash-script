# Nexus Installation Scripts for Ubuntu, Amazon Linux (AWS EC2), and RHEL/CentOS

This repository contains scripts to automate the installation of Nexus Repository Manager on Ubuntu, Amazon Linux (AWS EC2), and RHEL/CentOS. Each script installs Nexus, configures it, and starts the service. The scripts are designed to run with root permissions.

## Prerequisites

- **Supported Operating Systems**: Ubuntu, Amazon Linux (AWS EC2), and RHEL/CentOS.
- **Root Permissions**: The scripts must be run with root permissions (e.g., using `sudo`).
- **Internet Connection**: The scripts require internet access to download Nexus and Java 1.8.

## How to Use

1. **Choose the Appropriate Script**: Select the script that matches your operating system: 
    - `install-nexus-ubuntu.sh` for Ubuntu.
    - `install-nexus-aws-linux.sh` for Amazon Linux (AWS EC2).
    - `install-nexus-rhel-centos.sh` for RHEL/CentOS.

2. **Download the Script**: Save the selected script to your system.

3. **Make the Script Executable**: Run the following command to make the script executable:
    ```shell
    chmod +x scriptname.sh
    ```

4. **Run the Script**: Execute the script as root to install Nexus:
    ```shell
    sudo ./scriptname.sh
    ```

5. **Follow the Instructions**: Once the script completes, it will print the URL to access Nexus and the initial admin password.

## What the Scripts Do

- **Java Installation**: Installs Java 1.8 on the system.
- **User Creation**: Creates a Nexus user and group if they don't exist.
- **Nexus Download and Installation**: Downloads and extracts Nexus to `/opt/nexus/nexus`.
- **Nexus Configuration**: Configures Nexus to use `/opt/nexus/sonatype-work/nexus3` as its working directory and sets appropriate permissions.
- **Systemd Service**: Creates a systemd service for Nexus, enabling easy management of the Nexus service.
- **Starting Nexus**: Starts the Nexus service.
- **Displaying Admin Password**: Prints the URL to access Nexus and the initial admin password.

## Notes

- **Firewall**: The scripts do not configure firewalls, as AWS EC2 instances typically rely on security groups.
- **Error Handling**: The scripts stop execution on any error to prevent partial installations.

## Thank You

Thank you for using these scripts! If you encounter any issues or have suggestions for improvements, feel free to provide feedback.
