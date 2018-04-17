echo 'export OCP_WILDCARD_DOMAIN=apps.$EXTERNAL_IP.nip.io' >> .bashrc
source .bashrc
oc-cluster-wrapper/oc-cluster up 3scale-amp --public-hostname $EXTERNAL_IP --routing-suffix $OCP_WILDCARD_DOMAIN 
