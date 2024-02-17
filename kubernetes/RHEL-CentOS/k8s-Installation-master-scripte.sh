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

yum install -y yum-utils dnf iproute-tc
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

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

cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/
enabled=1
gpgcheck=0
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

echo
echo '#######################################################################################
      Start the Kubernetes services and enable them
      #######################################################################################'
echo

sudo systemctl enable --now kubelet

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
