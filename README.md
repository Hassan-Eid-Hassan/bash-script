# Bash Scripts Repository

Welcome to the Bash Scripts Repository! This repository contains scripts for installing and setting up Jenkins, Nexus, and Kubernetes on different Linux distributions, including AWS Linux, Ubuntu, and RHEL/CentOS. The scripts are organized in separate folders based on the software and target distribution.

## Repository Structure

- **Jenkins**: Contains scripts for installing Jenkins.
  - `jenkins-install-aws-linux.sh`: Script to install Jenkins on AWS Linux.
  - `jenkins-install-ubuntu.sh`: Script to install Jenkins on Ubuntu.
  - `jenkins-install-rhel-centos.sh`: Script to install Jenkins on RHEL/CentOS.

- **Nexus**: Contains scripts for installing Nexus.
  - `nexus-install-aws-linux.sh`: Script to install Nexus on AWS Linux.
  - `nexus-install-ubuntu.sh`: Script to install Nexus on Ubuntu.
  - `nexus-install-rhel-centos.sh`: Script to install Nexus on RHEL/CentOS.

- **Kubernetes**: Contains folders for different distributions, each with scripts to install Kubernetes.
  - **AWS Linux**:
    - `k8s-master-installation-aws-linux.sh`: Script to install Kubernetes master on AWS Linux.
    - `k8s-worker-installation-aws-linux.sh`: Script to install Kubernetes worker on AWS Linux.
  - **RHEL/CentOS**:
    - `k8s-master-installation-rhel-centos.sh`: Script to install Kubernetes master on RHEL/CentOS.
    - `k8s-worker-installation-rhel-centos.sh`: Script to install Kubernetes worker on RHEL/CentOS.

## Prerequisites

Before running the scripts, ensure you have the following:

- **Root access**: You need root access (or sudo privileges) to execute the scripts.
- **Operating system compatibility**: The scripts are designed to work with specific operating systems and may not be compatible with others.

## How to Use the Scripts

1. **Clone the repository**: Clone the repository to your local machine using Git:

    ```bash
    git clone https://github.com/Hassan-Eid-Hassan/bash-script.git
    ```

2. **Navigate to the desired directory**: Enter the directory of the desired software and target distribution:

    ```bash
    cd bash-script/[jenkins|nexus|kubernetes]/[aws-linux|ubuntu|rhel-centos]
    ```

3. **Make the script executable**: Run the following command to make the script executable:

    ```bash
    chmod +x [script-name.sh]
    ```

4. **Run the script**: Execute the script with the appropriate privileges:

    ```bash
    sudo ./[script-name.sh]
    ```

## Logs and Output

- All scripts output logs to a specified log file (e.g., `/var/log/jenkins_install.log`).
- The logs contain important information about the installation process, including errors, warnings, and progress messages.

## Troubleshooting

- If you encounter any issues, check the logs for error messages and potential solutions.
- Ensure that you have the required network connectivity and dependencies installed on your system.

## Contribution Guidelines

- Contributions, such as issues, pull requests, and feedback, are welcome.
- Please follow the repository's guidelines and code of conduct when contributing.

## Thank You

Thank you for using these scripts! We hope they make your installation process easier. If you encounter any issues or have feedback, please feel free to raise an issue or pull request on the repository.