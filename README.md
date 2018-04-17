# installing 3scale AMP 2.0 on OpenShift 3.5

These are the instructions in a [Red Hat Developers 3scale blog post](https://developers.redhat.com/blog/2017/05/22/how-to-setup-a-3scale-amp-on-premise-all-in-one-install/) in bash form

It installs OpenShift 3.5 and dependencies on a single node cluster, and deploys 3scale on OpenShift

instructions.sh - lists the commands in order. You should be able to run 
    
    ./instructions.sh

Note: 

Make sure $EXTERNAL_IP and $RH_USER_NAME are set

Look at the instructions.sh script and uncomment the appropriate commands


If you want to use ansible playbooks to install OCP [use this](https://github.com/gbengataylor/ocp-ansible-playbooks)

Future plan is to add a playbook or pipeline for deploying 3scale
