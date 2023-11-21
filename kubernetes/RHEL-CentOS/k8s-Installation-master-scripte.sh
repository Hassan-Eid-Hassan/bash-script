#!/bin/bash

echo '############################################
      Remove the old version of Docker
      ############################################'
echo

yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine podman runc -y

echo
echo '############################################
      Remove old version of K8s
      ############################################'
echo

yum remove kube* -y

find / -name "kube*" -type d -exec rm -vfr {} \;
find / -name "kube*" -type s -exec rm -vf {} \;
find / -name "kube*" -type f -exec rm -vf {} \;

echo
echo '############################################
      Disable SELinux enforcement
      ############################################'
echo

setenforce 0

sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux


echo
echo '###############################################
      Set bridged packets to traverse iptables rules
      ###############################################'
echo

cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

echo 1 > /proc/sys/net/ipv4/ip_forward

sysctl --system

echo
echo '#################################################
      Disable all memory swaps to increase performance
      #################################################'
echo

swapoff -a

echo '############################################################
      #####     NOTE!!!: hash any swap in /etc/fstab     #########
      ############################################################'

echo
echo '####################################################################################################################
      Enable transparent masquerading and facilitate Virtual Extensible LAN (VxLAN) traffic for communication between Kubernetes pods across the cluster
      ####################################################################################################################'
echo

modprobe br_netfilter

echo
echo '#################################################
      Enable IP masquerade at the firewall
      #################################################'
echo

firewall-cmd --add-masquerade --permanent
firewall-cmd --reload

echo
echo '#######################################################
      Add the repository for the docker installation package
      #######################################################'
echo

yum install -y yum-utils dnf
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
dnf install -y docker-ce

echo
echo '########################################################
      Start the docker service
      ########################################################'
echo

systemctl start docker
systemctl enable docker

echo
echo '#######################################################
      Change docker to use systemd cgrouyp driver
      #######################################################'
echo

echo '{
  "exec-opts": ["native.cgroupdriver=systemd"]
}' > /etc/docker/daemon.json

systemctl restart docker

echo
echo '#######################################################################################
      Add the Kubernetes repository and  Install all the necessary components for Kubernetes
      #######################################################################################'
echo

touch /etc/yum.repos.d/kubernetes.repo
echo '[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-$basearch
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl' > /etc/yum.repos.d/kubernetes.repo

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

echo
echo '#######################################################################################
      Start the Kubernetes services and enable them
      #######################################################################################'
echo

systemctl enable kubelet
systemctl start kubelet

echo
echo '#######################################################################################
      Adding the K8s ports to firewall
      #######################################################################################'
echo

firewall-cmd --permanent --add-port=6443/tcp
firewall-cmd --permanent --add-port=2379-2380/tcp
firewall-cmd --permanent --add-port=10250/tcp
firewall-cmd --permanent --add-port=10251/tcp
firewall-cmd --permanent --add-port=10252/tcp
firewall-cmd --permanent --add-port=10255/tcp
firewall-cmd --reload

echo
echo '#######################################################################################
      ensur that "iproute-tc" installed corructrlly
      #######################################################################################'
echo

yum install -y iproute-tc

echo
echo '#######################################################################################
      Configure kubeadm and creating cluster
      #######################################################################################'
echo

mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
systemctl restart containerd

kubeadm init --pod-network-cidr 192.168.0.0/16

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=/etc/kubernetes/admin.conf

echo
echo '#######################################################################################
      Setup Pod Network
      #######################################################################################'
echo

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

echo
echo '#######################################################################################
      ALL GOOD ... YOU DID GREATE <3
      ------------------------------
      To join the worker in your cluster ... Please take the command generated from kubeadm init and pasted in the worker.
      
      The command like:
      kubeadm join 192.168.1.16:6443 --token s5ukm8.vow9nnltdvrq6as2 --discovery-token- ...
      #######################################################################################'
