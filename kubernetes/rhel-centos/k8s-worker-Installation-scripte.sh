#!/bin/bash

set -e  # Exit script on any command failure

# Constants
DOCKER_REPO_URL="https://download.docker.com/linux/centos/docker-ce.repo"
K8S_REPO_URL="https://pkgs.k8s.io/core:/stable:/v1.29/rpm/"
K8S_GPG_KEY="https://pkgs.k8s.io/core:/stable:/v1.29/rpm/repodata/repomd.xml.key"
LOG_FILE="/var/log/k8s_install.log"
AUTO_HASH_SWAP="true"

# Usage function
usage() {
    echo "Usage: $0"
    echo "This script installs Kubernetes worker on a new server."
    echo "Logs are stored at $LOG_FILE"
}

# Function to log output to file
log_output() {
    exec &> >(tee -a "$LOG_FILE")
}

# Function to install Docker
install_docker() {
    echo "Installing Docker..."
    yum install -y yum-utils dnf iproute-tc
    yum-config-manager --add-repo "$DOCKER_REPO_URL"
    yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
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
    cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=$K8S_REPO_URL
enabled=1
gpgcheck=0
gpgkey=$K8S_GPG_KEY
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF
    sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
    sudo systemctl enable --now kubelet
    echo "Kubernetes installation completed."
}

# Function to configure firewall
configure_firewall() {
    echo "Configuring firewall..."
    firewall-cmd --permanent --add-port=6443/tcp
    firewall-cmd --permanent --add-port=2379-2380/tcp
    firewall-cmd --permanent --add-port=10250/tcp
    firewall-cmd --permanent --add-port=10251/tcp
    firewall-cmd --permanent --add-port=10252/tcp
    firewall-cmd --permanent --add-port=10255/tcp
    firewall-cmd --add-masquerade --permanent
    firewall-cmd --reload
    echo "Firewall configuration completed."
}

# Configure containerd
configure_containerd() {
    echo "Configure containerd..."

    mkdir -p /etc/containerd
    containerd config default > /etc/containerd/config.toml
    systemctl restart containerd

    echo "Containerd configured."
}

# Main function to execute all steps
main() {
    log_output
    echo "Starting Kubernetes worker installation..."
    
    echo "Step 1: Removing old versions..."
    yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine podman runc kube* -y

    echo "Step 2: Disabling SELinux..."
    setenforce 0
    sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

    echo "Step 3: Setting bridged packets to traverse iptables rules..."
    cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
    echo 1 > /proc/sys/net/ipv4/ip_forward
    sysctl --system

    echo "Step 4: Disabling all memory swaps..."
    swapoff -a
    if [ $AUTO_HASH_SWAP == "true" ]
    then
        sed -i '/\sswap\s/s/^/#/' /etc/fstab
    fi 
    echo "Please check any swap entries in /etc/fstab."

    echo "Step 5: Enabling transparent masquerading and VxLAN..."
    modprobe br_netfilter

    # Install Docker and Kubernetes
    install_docker
    configure_docker
    install_k8s
    configure_containerd

    echo "Step 6: Configuring firewall..."
    configure_firewall

    echo "Installation completed successfully."
}

# Run the main function
main
