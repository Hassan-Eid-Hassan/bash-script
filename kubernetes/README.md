# Kubernetes and Docker Installation Scripts

## Overview
These scripts automate the installation and configuration of Kubernetes and Docker on CentOS/RHEL, AWS-Linux and Ubuntu servers. They remove old versions of Docker and Kubernetes, install necessary packages, and set up Kubernetes clusters.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Configuration](#configuration)
- [How to Execute the Script](#how-to-execute-the-script)
- [Troubleshooting](#troubleshooting)
    - [Swap Issues](#swap-issues)
    - [Networking Issues](#networking-issues)
    - [CRI and Containerd Issues](#cri-and-containerd-issues)
- [Thank You](#thank-you)

## Prerequisites
- Minimal requirements for Master Node:
    - 2 CPUs
    - 2.5 GiB of RAM

- Configure `/etc/hosts` file:
    ```bash
    sudo vi /etc/hosts
    ```

    Example:
    ```plaintext
    192.168.15.1  k8s
    192.168.15.2  worker1
    192.168.15.3  worker2
    ```

- Disable all swap:
    ```bash
    sudo swapoff -a
    ```

    Ensure all swap entries in `/etc/fstab` are commented out:
    ```plaintext
    #/dev/mapper/cl_dhcp-swap none swap defaults 0 0
    ```

## Configuration
- Set up bridged packets to traverse iptables rules.
- Disable all memory swaps to increase performance.
- Enable transparent masquerading and facilitate Virtual Extensible LAN (VxLAN) traffic for communication between Kubernetes pods across the cluster.
- Enable IP masquerade at the firewall.

## How to Execute the Script
- First, make the script executable:
    ```bash
    sudo chmod +x scriptname.sh
    ```

- Execute the script using one of the following methods:

    **Method 1:**
    ```bash
    sudo ./scriptname.sh
    ```

    **Method 2:**
    ```bash
    sudo bash scriptname.sh
    ```

## Troubleshooting
### Swap Issues
- If you encounter a warning that swap is enabled, disable swap using:
    ```bash
    sudo swapoff -a
    ```

- Ensure all swap entries in `/etc/fstab` are commented out.

### Networking Issues
- Failed to create pod sandbox: RPC error due to NetworkPlugin CNI failing to set up pod network.

    **Solution:**
    - On both master and worker nodes:
        ```bash
        kubeadm reset
        sudo rm -rf /etc/cni/net.d/* $HOME/.kube/config
        ```

    - On the master node only:
        - Re-run `kubeadm init --pod-network-cidr=192.168.0.0/16`.
        - Reconfigure Kubernetes:
            ```bash
            mkdir -p $HOME/.kube
            sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
            sudo chown $(id -u):$(id -g) $HOME/.kube/config
            ```
        - Apply the Calico manifest:
            ```bash
            kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
            ```

- To check the status of the cluster and nodes:
    ```bash
    kubectl get nodes
    ```

### CRI and Containerd Issues
- If you encounter errors with the container runtime or containerd, follow these steps:

    **Error:** "[ERROR CRI]: container runtime is not running: output: time=... unknown service runtime.v1alpha2.RuntimeService"

    **Solution:**
    ```bash
    sudo rm /etc/containerd/config.toml
    sudo mkdir -p /etc/containerd
    containerd config default | sudo tee /etc/containerd/config.toml
    sudo systemctl restart containerd
    ```

- If you experience issues with the kubelet health check (HTTP call to localhost:10248/healthz), try the following:

    **Error:** "[kubelet-check] The HTTP call equal to 'curl -sSL http://localhost:10248/healthz' failed with error: Get "http://localhost:10248/healthz": dial tcp [::1]:10248: connect: connection refused."

    **Solution:**
    ```bash
    sudo swapoff -a
    ```

## Thank You
Thank you for using the scripts. If you encounter any issues or have suggestions for improvement, please feel free to open an issue or contribute to the repository.