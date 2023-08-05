#!/bin/bash

echo 'Remove the old version of Docker'
echo

yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine podman runc -y

echo
echo 'Remove old version of K8s'
echo

yum remove kube* -y

find / -name "kube*" -type d -exec rm -vfr {} \;
find / -name "kube*" -type s -exec rm -vf {} \;
find / -name "kube*" -type f -exec rm -vf {} \;

echo
echo 'Disable SELinux enforcement'
echo

setenforce 0

sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

echo
echo 'Set bridged packets to traverse iptables rules'
echo

cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

echo 1 > /proc/sys/net/ipv4/ip_forward

sysctl --system

echo
echo 'Disable all memory swaps to increase performance'
echo

swapoff -a


echo
echo 'Enable transparent masquerading and facilitate Virtual Extensible LAN (VxLAN) traffic for communication between Kubernetes pods across the cluster'
echo

modprobe br_netfilter


echo
echo 'Add the repository for the docker installation package'
echo

yum install -y yum-utils dnf
yum install -y docker

echo
echo 'Start the docker service'
echo

systemctl start docker
systemctl enable docker

echo
echo 'Change docker to use systemd cgrouyp driver'
echo

echo '{
  "exec-opts": ["native.cgroupdriver=systemd"]
}' > /etc/docker/daemon.json

systemctl restart docker

echo
echo 'Add the Kubernetes repository and  Install all the necessary components for Kubernetes'
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
echo 'Start the Kubernetes services and enable them'
echo

systemctl enable kubelet
systemctl start kubelet


echo
echo 'ensur that "iproute-tc" installed corructrlly'
echo

yum install -y iproute-tc

echo
echo 'PREREQUISITES FOR WORKER NODES'
echo

mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
systemctl restart containerd
