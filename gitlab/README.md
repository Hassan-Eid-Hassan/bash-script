<a href="https://about.gitlab.com">
    <img src="https://images.ctfassets.net/xz1dnu24egyd/1hnQd13UBU7n5V0RsJcbP3/769692e40a6d528e334b84f079c1f577/gitlab-logo-100.png" alt="GitLab logo"> 
</a>

# GitLab Installation Scripts

This repository contains scripts to install GitLab on different Linux distributions, including Ubuntu, Amazon Linux (EC2), and RHEL/CentOS. These scripts automate the process of installing and configuring GitLab Community Edition (CE), making it easy to deploy GitLab on your server.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Scripts](#scripts)
  - [GitLab Installation on Ubuntu](#gitlab-installation-on-ubuntu)
  - [GitLab Installation on Amazon Linux EC2](#gitlab-installation-on-amazon-linux-ec2)
  - [GitLab Installation on RHEL/CentOS](#gitlab-installation-on-rhelcentos)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## Prerequisites

- **Internet connection**: The scripts download packages from the GitLab repository and other sources.
- **Root privileges**: The scripts require `sudo` access to install and configure software.

## Scripts

### GitLab Installation on Ubuntu

- Script: `install-gitlab-ubuntu.sh`
- This script installs GitLab CE on an Ubuntu server. It updates system packages, adds the GitLab repository, installs GitLab CE, and configures it.
- After installation, the script provides the URL to access GitLab and the initial root password.

### GitLab Installation on Amazon Linux EC2

- Script: `install-gitlab-aws-ec2.sh`
- This script installs GitLab CE on an Amazon Linux EC2 instance. It updates system packages, adds the GitLab repository, installs GitLab CE, and configures it.
- After installation, the script provides the URL to access GitLab and the initial root password.

### GitLab Installation on RHEL/CentOS

- Script: `install-gitlab-rhel-centos.sh`
- This script installs GitLab CE on a RHEL or CentOS server. It updates system packages, adds the GitLab repository, installs GitLab CE, and configures it.
- After installation, the script provides the URL to access GitLab and the initial root password.

## Usage

To use any of the scripts, follow the instructions below:

1. Clone this repository to your server:

   ```shell
   git clone https://github.com/your-username/your-repo.git
   cd your-repo
   ```
   
2. Make the script executable:

    ```shell
    chmod +x script-name.sh
    ```

3. Run the script with root privileges:

    ```shell
    sudo ./script-name.sh
    ```

4. Follow the instructions provided by the script to complete the installation.

## Troubleshooting

- If you encounter any issues during installation, check the script's output for error messages.
- Ensure that you have an active internet connection and the necessary permissions to execute the script.
