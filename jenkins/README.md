# Jenkins Installation Script

This script automates the installation and setup of Jenkins on Ubuntu.

## How the Script Works

1. **Java 17 Installation**: Prompts you to install Java 17 if it's not already present on your system.
2. **Jenkins Repository**: Adds the Jenkins repository and GPG key to ensure secure and verified installations.
3. **Jenkins Installation**: Installs Jenkins and starts the Jenkins service.
4. **Service Management**: Enables the Jenkins service to run automatically on system startup.
5. **Firewall Configuration**: Configures the firewall to allow traffic on the default Jenkins port (8080).

## Execution Instructions

- **First Method:**
  ```bash
  chmod +x scriptname.sh
  sudo ./scriptname.sh
```
- **Second Method:**
```bash
sudo bash "scriptname.sh"
```

## Final Steps
Follow the script's final output for instructions on accessing your Jenkins installation and retrieving the initial admin password.

Thank you for using the Jenkins installation script! Let us know if you have any issues or feedback.