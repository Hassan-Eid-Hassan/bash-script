# Jenkins Installation Scripts

This repository contains scripts to automate the installation of Jenkins on different Linux distributions: Ubuntu, AWS Linux (Amazon Linux), and RHEL/CentOS.

## Scripts

1. **Ubuntu**: `jenkins-install-ubuntu.sh` installs Jenkins on Ubuntu. It handles the installation of Java 17, adding the Jenkins repository and key, and installing Jenkins. Additionally, the script starts and enables the Jenkins service.

2. **AWS Linux (Amazon Linux)**: `jenkins-install-aws-linux.sh` installs Jenkins on AWS Linux (Amazon Linux). It follows a similar process to the Ubuntu script but uses yum for package management.

3. **RHEL/CentOS**: `jenkins-install-rhel-centos.sh` installs Jenkins on RHEL/CentOS. It follows a similar process to the other scripts, handling the installation of Java 17, Jenkins repository and key, and starting the Jenkins service.

## Prerequisites

- **Supported Operating Systems**: Ubuntu, AWS Linux (Amazon Linux), RHEL/CentOS.
- **Root Permissions**: The scripts must be run with root permissions (e.g., using `sudo`).
- **Internet Connection**: The scripts require internet access to download Jenkins and its dependencies.

## How to Use

1. **Download the Script**: Save the appropriate script for your operating system (e.g., `jenkins-install-ubuntu.sh`) to your server.

2. **Make the Script Executable**: Run the following command to make the script executable:
    ```shell
    chmod +x script_name.sh
    ```

3. **Run the Script**: Execute the script as root to install Jenkins:
    ```shell
    sudo ./script_name.sh
    ```

4. **Follow the Instructions**: Once the script completes, it will print the URL to access Jenkins and the location of the initial admin password.

## What the Scripts Do

- **Java 17 Installation**: Prompts the user to install Java 17 if desired (Ubuntu and AWS Linux) or automatically installs it (RHEL/CentOS).
- **Jenkins Repository and Key**: Adds the Jenkins repository and imports its GPG key.
- **Jenkins Installation**: Installs Jenkins using the repository added earlier.
- **Jenkins Service Management**: Starts and enables the Jenkins service.
- **Git Installation**: Installs Git.

## Logs

The scripts log their actions to `/var/log/jenkins_install.log` on AWS Linux and RHEL/CentOS. For Ubuntu, the logs are redirected to standard output.

## Thank You

Thank you for using these scripts! If you encounter any issues or have suggestions for improvements, feel free to provide feedback.