# Nexus Installation Scripts for Ubuntu, Amazon Linux (AWS EC2), and RHEL/CentOS

This repository contains scripts to automate the installation of Nexus Repository Manager (latest version) on Ubuntu, Amazon Linux (AWS EC2), and RHEL/CentOS. Each script installs Nexus, configures it, and starts the service. The scripts are designed to run with root permissions.

## Prerequisites

- **Operating System**: Select the script that matches your operating system: 
    - `nexus-install-ubuntu.sh` for Ubuntu.
    - `nexus-install-aws-linux.sh` for Amazon Linux (AWS EC2).
    - `install-install-rhel-centos.sh` for RHEL/CentOS.
- **Root Permissions**: The script must be run with root permissions (e.g., using `sudo`).
- **Internet Connection**: An active internet connection is required to download Nexus.

## What the Script Does

1. **Create Nexus User and Group**: The script creates a system user and group named `nexus` for managing Nexus.

2. **Install Java**: The script installs OpenJDK 1.8, which is required to run Nexus.

3. **Download and Install Nexus**: The script downloads the latest version of Nexus and installs it in `/opt/nexus`.

4. **Configure Nexus**: The script configures Nexus and sets its data directory to `/opt/sonatype-work/nexus3`.

5. **Create Nexus Systemd Service**: The script creates a systemd service for Nexus, allowing it to start automatically at system boot and providing easy control of the service.

6. **Configure Firewall**: The script configures the firewall to allow traffic on ports 8081 (TCP and UDP), which Nexus uses. (RHEL/CentOS/ubuntu)

7. **Start Nexus**: The script starts the Nexus service.

8. **Display Nexus Admin Password**: The script displays the location of the Nexus admin password, which is required for the initial login.

## How to Use the Script

1. **Download the Script**: Save the script to the server.

2. **Make the Script Executable**: Run the following command to make the script executable:

    ```bash
    chmod +x nexus-install-[distribute].sh
    ```

3. **Run the Script**: Execute the script with root privileges:

    ```bash
    sudo ./nexus-install-[distribute].sh
    ```

4. **Follow the Output**: The script will guide you through the installation process and provide access information once installation is complete.

## Customization

- **Nexus Version**: The script automatically fetches the latest version of Nexus. You can modify the `NEXUS_URL` variable to specify a different version or URL.

- **Installation Paths**: Customize the installation and data directories by changing the `INSTALL_DIR` variable.

- **Firewall Settings**: Modify the `FIREWALL_ZONE` variable to set the appropriate firewall zone and update the port configuration as needed. (RHEL/CentOS/ubuntu)

## Troubleshooting

- **Check the Logs**: If you encounter any issues, check the installation log file (`/var/log/nexus_install.log`) for error messages and troubleshooting information.

- **Error Messages**: If the script encounters an error, it will stop execution. Follow the error messages in the log file for troubleshooting.

## Contribution Guidelines

Contributions, such as issues, pull requests, and feedback, are welcome. Please follow the repository's guidelines and code of conduct when contributing.

## Thank You

Thank you for using these scripts! If you encounter any issues or have suggestions for improvements, feel free to provide feedback.
