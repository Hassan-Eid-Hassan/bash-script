#!/bin/bash

# Exit script on any command failure
set -e

# Log file location
LOG_FILE="/var/log/jenkins_install.log"

# Redirect output to log file
exec &> >(tee -a "$LOG_FILE")

# Install Java 17

echo "Installing Java 17..."
sudo yum update -y
sudo yum install -y java-17-openjdk java-17-openjdk-devel
echo "Java 17 installed."

# Add Jenkins repository and key
echo "Adding Jenkins repository..."
wget -q -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo || true

echo "Importing the GPG key..."
# Import Jenkins GPG key
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key || true

echo "Installing Jenkins..."
# Install Jenkins
sudo yum update -y
sudo yum install -y jenkins

# Add the Jenkins port to the firewall
echo "Adding the Jenkins port to the firewall..."
firewall-cmd --permanent --zone=public --add-port=8080/tcp
firewall-cmd --reload

echo "Starting and enabling Jenkins service..."
# Start and enable Jenkins service
sudo systemctl enable --now jenkins

echo "Installing Git..."
# Install Git 
sudo yum install -y git 

# Provide instructions to the user to access Jenkins
echo "To set up Jenkins, visit:"
echo "http://$(hostname -I | awk '{print $1}'):8080"
echo "Find the initial admin password in /var/lib/jenkins/secrets/initialAdminPassword"
