#!/bin/bash

# Exit script on any command failure
set -e

# Log file location
LOG_FILE="/var/log/jenkins_install.log"

# Redirect output to log file
exec &> >(tee -a "$LOG_FILE")

# Install Java 21

echo "Installing Java 21..."
sudo apt update -y
sudo apt install -y fontconfig openjdk-21
echo "Java 21 installed."

# Add Jenkins repository and key
echo "Adding Jenkins repository..."
wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key || true
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null || true

# Install Jenkins
echo "Installing Jenkins..."
sudo apt update -y
sudo apt install -y jenkins

# Start and enable Jenkins service
echo "Starting and enabling Jenkins service..."
sudo systemctl enable --now jenkins

# Allow Jenkins port (8080) in UFW firewall
echo "Configuring firewall..."
if sudo ufw status | grep -q inactive; then
    sudo ufw enable
fi
sudo ufw allow 8080/tcp

echo "Installing Git..."
# Install Git
sudo yum install -y git 

# Provide instructions to the user to access Jenkins
echo "To set up Jenkins, visit:"
echo "http://$(hostname -I | awk '{print $1}'):8080"
echo "Find the initial admin password in /var/lib/jenkins/secrets/initialAdminPassword"