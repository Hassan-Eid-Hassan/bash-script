<a href="https://www.sonarsource.com/products/sonarqube/">
    <img align="center" width="500" src="https://cdn.worldvectorlogo.com/logos/sonarqube.svg" alt="Sonarqube logo"> 
</a>

# SonarQube Installation Scripts for Ubuntu, Amazon Linux (AWS EC2), and RHEL/CentOS

This repository contains scripts to automate the installation of SonarQube (latest version) on Ubuntu, Amazon Linux (AWS EC2), and RHEL/CentOS. Each script installs SonarQube, configures it, and starts the service. The scripts are designed to run with root permissions.

## Prerequisites

- **Operating System**: Select the script that matches your operating system:
    - `sonarqube-install-ubuntu.sh` for Ubuntu.
    - `sonarqube-install-aws-linux.sh` for Amazon Linux (AWS EC2).
    - `sonarqube-install-rhel-centos.sh` for RHEL/CentOS.
- **Root Permissions**: The script must be run with root permissions (e.g., using `sudo`).
- **Internet Connection**: An active internet connection is required to download SonarQube.

## What the Script Does

1. **Create SonarQube User and Group**: The script creates a system user and group named `sonarqube` for managing SonarQube.

2. **Install Java**: The script installs OpenJDK 17, which is required to run SonarQube.

3. **Download and Install SonarQube**: The script downloads the specified version of SonarQube and installs it in `/opt/sonarqube`.

4. **Configure SonarQube**: The script configures SonarQube settings such as the data directory, logs directory, and database connection details.

5. **Create SonarQube Systemd Service**: The script creates a systemd service for SonarQube, allowing it to start automatically at system boot and providing easy control of the service.

6. **Start SonarQube**: The script starts the SonarQube service.

7. **Display Access Information**: The script displays information on how to access SonarQube, including the URL and default login credentials.

## How to Use the Script

1. **Download the Script**: Save the script to the server.

2. **Make the Script Executable**: Run the following command to make the script executable:

    ```bash
    chmod +x sonarqube-install-[distro].sh
    ```

3. **Run the Script**: Execute the script with root privileges:

    ```bash
    sudo ./sonarqube-install-[distro].sh
    ```

4. **Follow the Output**: The script will guide you through the installation process and provide access information once installation is complete.

## Customization

- **SonarQube Version**: The script automatically fetches the specified version of SonarQube. Modify the `SONARQUBE_VERSION` and `SONARQUBE_DOWNLOAD_URL` variables to specify a different version or URL.

- **Installation Paths**: Customize the installation directory (`INSTALL_DIR`) and data directory (`DATA_DIR`) by modifying the corresponding variables in the script.

- **Database Connection**: Update the database server IP, user, password, and name by modifying the `PG_DB_SERVER_IP`, `SONARQUBE_DB_USER`, `SONARQUBE_DB_PASS`, and `SONARQUBE_DB_NAME` variables in the script.

## Troubleshooting

- **Check the Logs**: If you encounter any issues, check the log file (`/var/log/sonarqube-install.log`) for error messages and troubleshooting information.

- **Error Messages**: If the script encounters an error, it will stop execution. Follow the error messages in the log file for troubleshooting.

## Contribution Guidelines

Contributions, such as issues, pull requests, and feedback, are welcome. Please follow the repository's guidelines and code of conduct when contributing.

## Thank You

Thank you for using these scripts! If you encounter any issues or have suggestions for improvements, feel free to provide feedback. Happy coding!
