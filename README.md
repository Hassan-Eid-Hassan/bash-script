# Automated Installation Scripts for Jenkins, SonarQube, Nexus, GitLab, and Kubernetes

Welcome to the automated installation scripts repository for Jenkins, SonarQube, Nexus, GitLab, and Kubernetes. This repository contains scripts to facilitate the installation and configuration of these software solutions across various operating systems including Ubuntu, RHEL/CentOS, and Amazon Linux (AWS EC2).

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

### Jenkins

- **Ubuntu:** The script for Ubuntu can be found at `/jenkins/jenkins-install-ubuntu.sh`.
- **RHEL/CentOS:** The script for RHEL/CentOS can be found at `/jenkins/jenkins-install-rhel-centos.sh`.
- **Amazon Linux:** The script for Amazon Linux can be found at `/jenkins/jenkins-install-aws-linux.sh`.

These scripts install Jenkins and its dependencies, enable the Jenkins service, and provide access instructions.

### SonarQube

- **Ubuntu:** The script for Ubuntu can be found at `/sonarqube/sonarqube-install-ubuntu.sh`.
- **RHEL/CentOS:** The script for RHEL/CentOS can be found at `/sonarqube/sonarqube-install-rhel-centos.sh`.
- **Amazon Linux:** The script for Amazon Linux can be found at `/sonarqube/sonarqube-install-aws-linux.sh`.

These scripts handle SonarQube installation, configuration, and service management.

### Nexus

- **Ubuntu:** The script for Ubuntu can be found at `/nexus/nexus-install-ubuntu.sh`.
- **RHEL/CentOS:** The script for RHEL/CentOS can be found at `/nexus/nexus-install-rhel-centos.sh`.
- **Amazon Linux:** The script for Amazon Linux can be found at `/nexus/nexus-install-aws-linux.sh`.

These scripts automate Nexus installation, including setup, configuration, and service management.

### GitLab

- **Ubuntu:** The script for Ubuntu can be found at `/gitlab/gitlab-install-ubuntu.sh`.
- **RHEL/CentOS:** The script for RHEL/CentOS can be found at `/gitlab/gitlab-install-rhel-centos.sh`.
- **Amazon Linux:** The script for Amazon Linux can be found at `/gitlab/gitlab-install-aws-linux.sh`.

These scripts manage GitLab installation and configuration for the specified operating systems.

### Kubernetes

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
