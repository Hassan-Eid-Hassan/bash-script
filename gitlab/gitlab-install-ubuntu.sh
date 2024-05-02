#!/bin/bash

# Exit the script on any command failure
set -e

# Function to install necessary dependencies
install_dependencies() {
    echo "Updating system packages..."
    sudo apt update

    echo "Installing dependencies..."
    sudo apt install -y curl openssh-server ca-certificates

    echo "Dependencies installed."
}

# Function to add the GitLab repository and install GitLab
install_gitlab() {
    echo "Adding GitLab repository..."
    curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash

    echo "Installing GitLab CE..."
    sudo apt update
    sudo apt install -y gitlab-ce
}

# Function to configure GitLab
configure_gitlab() {
    echo "Configuring GitLab..."
    sudo gitlab-ctl reconfigure
}

# Function to display access information and initial login credentials
display_login_information() {
    echo "GitLab has been installed and configured."
    local ip_address
    ip_address=$(hostname -I | awk '{print $1}')
    
    echo "You can access GitLab at: http://$ip_address"
    
    # Display the initial root password
    if [ -f /etc/gitlab/initial_root_password ]; then
        local password
        password=$(sudo cat /etc/gitlab/initial_root_password)
        echo "Username: root"
        echo "Password: $password"
    else
        echo "Could not find the initial root password file."
        echo "Please check the documentation for further steps to retrieve the password."
    fi
}

# Main function to execute all steps
main() {
    install_dependencies
    install_gitlab
    configure_gitlab
    display_login_information
}

# Run the main function
main