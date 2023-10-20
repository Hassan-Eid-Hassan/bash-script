# CRITICAL INFORMATION
- What are these scripts and what Linux distribution could they run on?
  - These scripts install Kubernetes and Docker on new servers, then create a cluster on the master node.
  - They could run on Centos/RHEL 8/7.
- How do these scripts work?

  1- Remove the old versions of Docker and Kubernetes.
     - docker-client
     - docker-client-latest
     - docker-common
     - docker-latest
     - docker-latest-logrotate
     - docker-logrotate
     - docker-engine
     - podman
     - runc
     - kube*

  2- Disable SELinux enforcement.

  3- Set bridged packets to traverse iptables rules.

  4- Disable all memory swaps to increase performance.

  5- Enable transparent masquerading and facilitate Virtual Extensible LAN (VxLAN) traffic for communication between Kubernetes pods across the cluster and enable IP masquerade at the firewall.

  6- Add the Kubernetes and Docker repositories and install all the necessary components, then start and enable services.

  7- Change Docker to use systemd cgrouyp driver.

  8- Adding the Kubernetes ports to the firewall.

  9- Configure kubeadm and create a cluster.

# PREREQUISITES FOR MASTER AND WORKER NODES BEFORE RUNNING THE SCRIPTS.

- Minimal requirements for Master
  - 2 CPUs
  - 2.5 GiB of RAM
   
  Note: If you're using a VM, you can downgrade resources after joining the workers to the cluster.

- Configure Hosts
```
vi /etc/hosts
```
Like ...
```
192.168.15.1  k8s
192.168.15.2  worker1
192.168.15.3  worker2
```

- Hash all swaps in /etc/fstab
```
vi /etc/fstab
```
Like ...
```
#/dev/mapper/cl_dhcp-swap none                    swap    defaults        0 0
```
# How to execute the script?
- Frist way
```
sudo chmod +x "scriptname.sh"
```
```
./"scriptname.sh"
```
- Second way
```
sudo bash "scriptname.sh"
```
# Errors that may occur during or after the installation with solve
- [WARNING Swap]: swap is enabled; production deployments should disable swap unless testing the NodeSwap feature gate of the kubelet ...

  Solve:
  ```
  swapoff -a
  ```
  Hash all swaps in /etc/fstab
  
- [WARNING FileExisting-tc]: tc not found in system path error execution phase preflight: [preflight] Some fatal errors occurred ...

  Solve:
  ```
  dnf install -y iproute-tc
  ```
- [ERROR CRI]: container runtime is not running: output: time="2022-05-06T21 emented desc = unknown service runtime.v1alpha2.RuntimeService"

  Solve:
  ```
  yes | rm /etc/containerd/config.toml
  mkdir -p /etc/containerd
  containerd config default > /etc/containerd/config.toml
  systemctl restart containerd
  ```
- Failed to create pod sandbox: rpc error: code = Unknown desc = failed to setup network for sandbox "72650e68f6cdb67e9d212d443df8c6a73d008d03296fef699dad19f1f66a8eea": plugin type="calico" failed (add): stat /var/lib/calico/nodename: no such file or directory: check that the calico/node container is running and has mounted /var/lib/calico/

  Solve:
  Check that the calico/node container is running and has mounted /var/lib/calico/
  ```
  kubectl get pods --all-namespaces
  ```
  Like ...
  ```
  kube-system   calico-kube-controllers-77484fbbb5-wwnwf   0/1     ContainerCreating   0          10m
  kube-system   calico-node-9pdlw                          0/1     Running             0          10m
  kube-system   calico-node-r9lqg                          0/1     Running             0          9m25s
  kube-system   calico-node-wlz4j                          0/1     Running             0          9m26s
  kube-system   coredns-6d4b75cb6d-8dvlk                   1/1     Running             0          10m
  kube-system   coredns-6d4b75cb6d-cr7sw                   1/1     Running             0          10m
  kube-system   etcd-k8s                                   1/1     Running             7          11m
  kube-system   kube-apiserver-k8s                         1/1     Running             7          11m
  kube-system   kube-controller-manager-k8s                1/1     Running             0          11m
  kube-system   kube-proxy-496k8                           1/1     Running             0          9m26s
  kube-system   kube-proxy-64ps6                           1/1     Running             0          10m
  kube-system   kube-proxy-fx784                           1/1     Running             0          9m26s
  kube-system   kube-scheduler-k8s                         1/1     Running             8          11m
  ```
- Failed create pod sandbox: rpc error: code = Unknown desc = NetworkPlugin cni failed to set up pod network

  Solve:
 - On master and workers
   ```
   kubeadm reset
   rm -rf /etc/cni/net.d/* && rm -rf $HOME/.kube/config
   ```
 - On master only
 
   1-
   ```
   kubeadm init --pod-network-cidr 192.168.0.0/16
   ```
   2-
   ```
   mkdir -p $HOME/.kube
   sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
   sudo chown $(id -u):$(id -g) $HOME/.kube/config
   ```
   3-
   ```
   kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
   ```
   4- Join the worker to the cluster and wait till they get ready, to check ...
   ```
   kubectl get nodes
   ```
- [kubelet-check] The HTTP call equal to 'curl -sSL http://localhost:10248/healthz' failed with error: Get "http://localhost:10248/healthz": dial tcp [::1]:10248: connect: connection refused.

  Solve:
   ```
   swapoff -a
   ```
################################################    THANK YOU    ################################################
