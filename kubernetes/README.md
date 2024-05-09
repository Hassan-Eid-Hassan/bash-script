<a href="https://kubernetes.io">
    <img width="500" src="https://upload.wikimedia.org/wikipedia/commons/thumb/6/67/Kubernetes_logo.svg/2560px-Kubernetes_logo.svg.png" alt="Kubernetes logo"> 
</a>

# Kubernetes Installation Scripts for Amazon Linux and RHEL/CentOS

This repository contains scripts to automate the installation and configuration of Kubernetes master and worker nodes on Amazon Linux and RHEL/CentOS. These scripts make setting up a Kubernetes cluster a straightforward process.

## Scripts

### Master Node Installation Scripts

- **Amazon Linux**: [k8s-master-installation-aws-linux.sh](aws-linux/k8s-master-installation-aws-linux.sh)
- **RHEL/CentOS**: [k8s-master-installation-rhel-centos.sh](rhel-centos/k8s-master-installation-rhel-centos.sh)

### Worker Node Installation Scripts

- **Amazon Linux**: [k8s-worker-installation-aws-linux.sh](aws-linux/k8s-worker-installation-aws-linux.sh)
- **RHEL/CentOS**: [k8s-worker-installation-rhel-centos.sh](rhel-centos/k8s-worker-installation-rhel-centos.sh)

## Prerequisites

- **Operating System**: Choose the script that matches your operating system (Amazon Linux or RHEL/CentOS).
- **Root Permissions**: The scripts must be run with root permissions (e.g., using `sudo`).
- **Internet Connection**: An active internet connection is required to download necessary packages.
- **Minimal requirements for Master Node**:
    - 2 CPUs
    - 2.5 GiB of RAM
- **Configure `/etc/hosts` file**:
    ```bash
    sudo vi /etc/hosts
    ```

    Example:
    ```plaintext
    192.168.15.1  k8s
    192.168.15.2  worker1
    192.168.15.3  worker2
    ```
- **Disable all swap**:
    ```bash
    sudo swapoff -a
    ```

    Ensure all swap entries in `/etc/fstab` are commented out:
    ```plaintext
    #/dev/mapper/cl_dhcp-swap none swap defaults 0 0
    ```

## What the Scripts Do

### Master Node Installation

1. **Install Docker**: Installs Docker and configures it with `systemd` as the cgroup driver.
2. **Install Kubernetes**: Adds the Kubernetes repository and installs `kubelet`, `kubeadm`, and `kubectl`.
3. **Configure Kubernetes**: Initializes the Kubernetes master node using a specified Pod network CIDR.
4. **Apply Pod Network**: Applies a Pod network (e.g., Calico) to the cluster.
5. **Print Join Command**: Outputs the join command to be used by worker nodes.

### Worker Node Installation

1. **Install Docker**: Installs Docker and configures it with `systemd` as the cgroup driver.
2. **Install Kubernetes**: Adds the Kubernetes repository and installs `kubelet`, `kubeadm`, and `kubectl`.
3. **Join the Cluster**: Joins the worker node to the Kubernetes cluster using the join command from the master node.

## How to Use the Scripts

1. **Download the Scripts**: Clone the repository or download the scripts.
2. **Make the Scripts Executable**: Run the following command to make the script executable:
    ```bash
    chmod +x k8s-master-installation-[os].sh
    chmod +x k8s-worker-installation-[os].sh
    ```
    Replace `[os]` with your operating system, either `aws-linux` or `rhel-centos`.

3. **Run the Script**: Execute the appropriate script with root privileges:

    For Master Node:
    ```bash
    sudo ./k8s-master-installation-[os].sh
    ```

    For Worker Node:
    ```bash
    sudo ./k8s-worker-installation-[os].sh
    ```

4. **Follow the Output**: The scripts will guide you through the installation process.

## Modifying the Scripts

The scripts can be customized to suit your needs:

- **Pod Network CIDR**: You can change the Pod network CIDR used during the Kubernetes cluster initialization by modifying the `POD_NETWORK_CIDR` variable in the master installation scripts.
- **Kubernetes Repository URL**: If you wish to use a different Kubernetes repository URL, you can change the value of the `K8S_REPO_URL` variable in the scripts.
- **GPG Key URL**: If you prefer to use a different GPG key URL for the repository, modify the `K8S_GPG_KEY` variable in the scripts.
- **Containerd Configuration**: You can further customize the containerd configuration if required by modifying the `configure_containerd` function.
- **Logging**: Modify the log file path by changing the `LOG_FILE` variable in the scripts.

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

## Contribution Guidelines

Contributions and feedback are welcome. Please follow the repository's guidelines when contributing.

## Thank You

Thank you for using these scripts! If you have any suggestions for improvements, feel free to provide feedback.
