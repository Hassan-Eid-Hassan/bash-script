#!/bin/bash

set -e  # Exit script on any command failure

# Constants
DOCKER_REPO_URL="https://download.docker.com/linux/ubuntu/gpg"
K8S_REPO_URL="https://pkgs.k8s.io/core:/stable:/v1.30/deb/"
K8S_GPG_KEY="https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key"
LOG_FILE="/var/log/k8s_install.log"
AUTO_HASH_SWAP="true"

# Usage function
usage() {
    echo "Usage: $0"
    echo "This script installs Kubernetes master on a new server."
    echo "Logs are stored at $LOG_FILE"
}

# Function to log output to file
log_output() {
    exec &> >(tee -a "$LOG_FILE")
}

# Function to install Docker
install_docker() {
    echo "Installing Docker..."
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl gpg
    
    # Add Docker GPG key and repository
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL "$DOCKER_REPO_URL" -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Install Docker
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    systemctl enable --now docker
    echo "Docker installation completed."
}

# Function to configure Docker
configure_docker() {
    echo "Configuring Docker..."
    cat <<EOF > /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  }
}
EOF
    systemctl restart docker
    echo "Docker configuration completed."
}

# Function to install Kubernetes
install_k8s() {
    echo "Installing Kubernetes..."
    # Add Kubernetes repository
    curl -fsSL "$K8S_GPG_KEY" | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] $K8S_REPO_URL /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl
    sudo systemctl enable --now kubelet
    echo "Kubernetes installation completed."
}

# Function to configure firewall
configure_firewall() {
    echo "Configuring firewall..."
    ufw allow 6443/tcp
    ufw allow 2379-2380/tcp
    ufw allow 10250/tcp
    ufw allow 10251/tcp
    ufw allow 10252/tcp
    ufw allow 10255/tcp
    ufw enable
    echo "Firewall configuration completed."
}

# Configure containerd
configure_containerd() {
    echo "Configure containerd..."

    mkdir -p /etc/containerd
    containerd config default > /etc/containerd/config.toml
    sudo sed -i 's/ SystemdCgroup = false/ SystemdCgroup = true/' /etc/containerd/config.toml
    systemctl restart containerd

    echo "Containerd configured."
}

# Main function to execute all steps
main() {
    log_output
    echo "Starting Kubernetes master installation..."
    
    echo "Step 1: Removing old versions..."
    for pkg in kubectl kubeadm kubelet docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg -y; done

    echo "Step 2: Setting bridged packets to traverse iptables rules..."
    cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

    cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
    sysctl --system

    echo "Step 3: Disabling all memory swaps..."
    swapoff -a
    if [ "$AUTO_HASH_SWAP" == "true" ]; then
        sed -i '/\sswap\s/s/^/#/' /etc/fstab
    fi 
    echo "Please check any swap entries in /etc/fstab."

    echo "Step 4: Enabling transparent masquerading and VxLAN..."
    sudo modprobe overlay
    sudo modprobe br_netfilter

    # Install Docker and Kubernetes
    install_docker
    configure_docker
    install_k8s
    configure_containerd

    echo "Step 5: Configuring firewall..."
    configure_firewall()


    echo "Installation completed successfully."
}

# Run the main function
main