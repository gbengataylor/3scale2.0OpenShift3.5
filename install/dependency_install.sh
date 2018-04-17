#java, keytool
yum install java

#mvn
#add the repo
wget https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo

sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
#install
yum install -y apache-maven
#version
 mvn --version
