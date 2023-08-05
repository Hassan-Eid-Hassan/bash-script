#!/bin/bash



echo '########################################################
      This script will install Jenkins and run it for you. <3
      ########################################################'
echo

echo 'Would you like to install Java 8 on your system? [y|n]'
read answer

while [ -n $answer -o -z $answer ]
do
if [ $answer = y -o $answer = Y ]
then 
     apt install default-jdk -y
     apt install default-jre -y
     break
elif [ $answer = n -o $answer = N ]
then
	break
else
	echo 'Invalid input! please choose correct option [ y | Y | n | N ]'
	read answer
fi
done


echo
echo '##########################
      Adding Jenkins repository
      ##########################'
echo      

yes | wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key |sudo gpg --dearmor -o /usr/share/keyrings/jenkins.gpg
sh -c 'echo deb [signed-by=/usr/share/keyrings/jenkins.gpg] http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt update

echo '############################################################
      Installing Jenkins
      ############################################################'
echo

apt install jenkins -y

echo
echo '##################################################################################
      Start the Jenkins services and enable them
      #################################################################################'
echo

systemctl start jenkins.service
systemctl enable jenkins

echo
echo '##################################################################################
      Adding the Jenkins port to the firewall
      #################################################################################'
echo

yes | ufw enable
ufw allow 8080

echo
echo '+++++++++++++++++++++++++++++  Status  +++++++++++++++++++++++++++++'

systemctl status jenkins
ufw status

echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
echo

echo "############################################################################
      To Run and Set up Jenkins please go to:
      -------------> http://`hostname -I | awk '{print $1}'`:8080 <-----------
      The Password is: `cat /var/lib/jenkins/secrets/initialAdminPassword`
      ############################################################################"
