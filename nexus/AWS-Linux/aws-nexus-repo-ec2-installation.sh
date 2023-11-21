#!/bin/bash

echo 'Changing Hostname to nexus'
echo

hostnamectl set-hostname nexus

echo 'Disabling SElinux if exists'
echo 

setenforce 0

echo 'Installing java 11'
echo

yum update -y
yum yum install java-11 -y

echo 'Creating /app Dir.'
echo
mkdir /app && cd /app


echo 'Installing Nexus'
echo

yum install wget -y
wget -O nexus.tar.gz https://download.sonatype.com/nexus/3/latest-unix.tar.gz
tar -xvf nexus.tar.gz
mv nexus-3* nexus

echo 'Adding nexus user and change the ownership'
echo

adduser nexus
chown -R nexus:nexus /app/nexus
chown -R nexus:nexus /app/sonatype-work

echo 'Configuring Nexus'
echo

echo 'run_as_user="nexus"' > /app/nexus/bin/nexus.rc

echo '[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/app/nexus/bin/nexus start
ExecStop=/app/nexus/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/nexus.service

chkconfig nexus on

echo 'Starting Nexus with user nexus'
echo

su nexus 

cd /app/nexus/bin

./nexus start

exit

echo
echo "THE Password: `cat /app/sonatype-work/nexus3/admin.password` "
echo
