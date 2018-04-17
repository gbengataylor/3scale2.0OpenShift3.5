#this works for rhel 73 and template/yml
cd install

./subs_manager_register.sh
./
yum install -y wget git net-tools bind-utils iptables-services bridge-utils bash-completion
./docker_install.sh 
 sed -i '/OPTIONS=.*/c\OPTIONS="--selinux-enabled --insecure-registry 172.30.0.0/16"' /etc/sysconfig/docker
 systemctl enable docker
 systemctl restart docker
#./firewald_install.sh
yum install -y atomic-openshift-clients

git clone https://github.com/openshift-evangelists/oc-cluster-wrapper
echo 'PATH=$HOME/oc-cluster-wrapper:$PATH' >> $HOME/.bash_profile
echo 'export PATH' >> $HOME/.bash_profile
source .bash_profile 
#optional: enable bash completion
$HOME/oc-cluster-wrapper/oc-cluster completion bash > /etc/bash_completion.d/oc-cluster.bash

wget https://raw.githubusercontent.com/3scale/3scale-amp-openshift-templates/2.0.0.GA/amp/amp.yml
# different template from lab
mkdir templates
cd templates
wget https://raw.githubusercontent.com/3scale/3scale-amp-openshift-templates/2.0.0.GA-redhat-2/amp/amp.yml
cd ..

#create oc cluster
#create_oc_cluster.sh

#run after oc-cluster-up
# sudo chcat -d /root/.oc/profiles/3scale-amp/volumes/vol{01..10}

#start app
#create_3scale_app.sh
#create_3scale_app2.sh

#oc get pods -w
