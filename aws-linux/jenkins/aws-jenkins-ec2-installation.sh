#!/bin/bash

echo 'Changing Hostname to jenkins'
echo  

hostnamectl set-hostname jenkins

echo 'Installing java 11'
echo  

yum update -y
yum install java-11 -y


echo 'Adding Jenkins repository'
echo      

wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo


echo 'Importing the GPG key to ensure your software is legitimate'
echo

`rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key`

echo 'Installing Jenkins'
echo

yum install jenkins -y


echo 'Start the Jenkins services and enable them'
echo

systemctl start jenkins
systemctl enable jenkins

echo 'Installing Git, Maven and Docker'
echo

yum install git -y
yum install maven -y

yum install docker -y

systemctl start docker
systemctl enable docker

chmod 777 /var/run/docker.sock