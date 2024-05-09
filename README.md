<h2 align="center">
    <img src="https://cdn.rawgit.com/odb/official-bash-logo/master/assets/Logos/Identity/PNG/BASH_logo-transparent-bg-color.png" alt="Bash Logo">
</h2>
<p align="center">
    <h1 align="center">Automated Installation Scripts for Jenkins, SonarQube, Nexus, GitLab, and Kubernetes</h1>
</p>
<h3 align="center">
    <img src="https://img.shields.io/github/license/Hassan-Eid-Hassan/bash-script?logoColor=white&label=License&color=F44336" alt="License Badge">
    <img src="https://img.shields.io/github/last-commit/Hassan-Eid-Hassan/bash-script?style=flat&logo=git&logoColor=white&color=FFFFFF" alt="Last Commit Badge">
    <img src="https://img.shields.io/github/languages/top/Hassan-Eid-Hassan/bash-script?style=flat&color=000000" alt="Top Language Badge">
</h3>

<p align="left">
    <strong>Welcome to the automated installation scripts repository!</strong> This project provides a collection of scripts for the seamless installation and configuration of Jenkins, SonarQube, Nexus, GitLab, and Kubernetes. These scripts are designed to work with various operating systems, including Ubuntu, RHEL/CentOS, and Amazon Linux (AWS EC2). 
</p>


## Table of Contents

- [Prerequisites](#prerequisites)
- [Scripts Overview](#scripts-overview)
  - [Jenkins](#jenkins)
  - [SonarQube](#sonarqube)
  - [Nexus](#nexus)
  - [GitLab](#gitlab)
  - [Kubernetes](#kubernetes)
- [How to Use the Scripts](#how-to-use-the-scripts)
- [Contribution Guidelines](#contribution-guidelines)
- [Thank You](#thank-you)

## Prerequisites

Before running the scripts, ensure you have the following:

- Root permissions or `sudo` access.
- An active internet connection.
- Supported operating system (Ubuntu, RHEL/CentOS, Amazon Linux).

## Scripts Overview

### [Jenkins](https://github.com/Hassan-Eid-Hassan/bash-script/tree/main/jenkins)

- **Ubuntu:** The script for Ubuntu can be found at `/jenkins/jenkins-install-ubuntu.sh`.
- **RHEL/CentOS:** The script for RHEL/CentOS can be found at `/jenkins/jenkins-install-rhel-centos.sh`.
- **Amazon Linux:** The script for Amazon Linux can be found at `/jenkins/jenkins-install-aws-linux.sh`.

These scripts install Jenkins and its dependencies, enable the Jenkins service, and provide access instructions.

### [SonarQube](https://github.com/Hassan-Eid-Hassan/bash-script/tree/main/sonarqube)

- **Ubuntu:** The script for Ubuntu can be found at `/sonarqube/sonarqube-install-ubuntu.sh`.
- **RHEL/CentOS:** The script for RHEL/CentOS can be found at `/sonarqube/sonarqube-install-rhel-centos.sh`.
- **Amazon Linux:** The script for Amazon Linux can be found at `/sonarqube/sonarqube-install-aws-linux.sh`.

These scripts handle SonarQube installation, configuration, and service management.

### [Nexus](https://github.com/Hassan-Eid-Hassan/bash-script/tree/main/nexus)

- **Ubuntu:** The script for Ubuntu can be found at `/nexus/nexus-install-ubuntu.sh`.
- **RHEL/CentOS:** The script for RHEL/CentOS can be found at `/nexus/nexus-install-rhel-centos.sh`.
- **Amazon Linux:** The script for Amazon Linux can be found at `/nexus/nexus-install-aws-linux.sh`.

These scripts automate Nexus installation, including setup, configuration, and service management.

### [GitLab](https://github.com/Hassan-Eid-Hassan/bash-script/tree/main/gitlab)

- **Ubuntu:** The script for Ubuntu can be found at `/gitlab/gitlab-install-ubuntu.sh`.
- **RHEL/CentOS:** The script for RHEL/CentOS can be found at `/gitlab/gitlab-install-rhel-centos.sh`.
- **Amazon Linux:** The script for Amazon Linux can be found at `/gitlab/gitlab-install-aws-linux.sh`.

These scripts manage GitLab installation and configuration for the specified operating systems.

### [Kubernetes](https://github.com/Hassan-Eid-Hassan/bash-script/tree/main/kubernetes)

The repository includes Kubernetes installation scripts for Amazon Linux and RHEL/CentOS.

- **Amazon Linux:** The scripts for Amazon Linux are located in the following directories:
  - Master installation: `/kubernetes/aws-linux/k8s-master-installation-aws-linux.sh`
  - Worker installation: `/kubernetes/aws-linux/k8s-worker-installation-aws-linux.sh`

- **RHEL/CentOS:** The scripts for RHEL/CentOS are located in the following directories:
  - Master installation: `/kubernetes/rhel-centos/k8s-master-installation-rhel-centos.sh`
  - Worker installation: `/kubernetes/rhel-centos/k8s-worker-installation-rhel-centos.sh`

These scripts install Kubernetes clusters, configure network settings, and manage nodes.

## How to Use the Scripts

1. Clone the repository:
    ```shell
    git clone https://github.com/Hassan-Eid-Hassan/bash-script.git
    ```
2. Navigate to the desired script directory.
3. Ensure the script has execution permissions (`chmod +x script.sh`).
4. Execute the script with root permissions:
    ```shell
    sudo ./script.sh
    ```

## Contribution Guidelines

Your contributions are welcome! Please follow the repository's contribution guidelines when submitting issues, pull requests, or feedback.

## Thank You

Thank you for using the automated installation scripts in this repository! If you encounter any issues or have suggestions for improvements, feel free to provide feedback. Happy coding!
