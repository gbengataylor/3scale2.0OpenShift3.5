#requires $SAAS_ACCESS_TOKEN and $THREESCALE_SAAS_TENANT_NAME
# using the gbenga-red-hat SAAS
#export THREESCALE_SAAS_TENANT_NAME=gbenga-red-hat
#need to get token from SaaS endpoint
#export SAAS_ACCESS_TOKEN=a0225f867228011a8d555811793788fc966c44410d09d5c9c24f49df09abeb3e
echo 'export THREESCALE_SAAS_TENANT_NAME=gbenga-red-hat' >> .bashrc 
echo 'export SAAS_ACCESS_TOKEN=a0225f867228011a8d555811793788fc966c44410d09d5c9c24f49df09abeb3e' >> .bashrc
source .bashrc

#test
curl -v https://${SAAS_ACCESS_TOKEN}@${THREESCALE_SAAS_TENANT_NAME}-admin.3scale.net/admin/api/services.json | python -m json.tool


oc adm new-project 3scale-apicast \
     --display-name="3scale-apicast" \
     --description="3scale apicast integrated with 3scale SaaS AMP" \
     --admin=developer \
     --as=system:admin

oc secret new-basicauth apicast-configuration-url-secret \
     --password=https://${SAAS_ACCESS_TOKEN}@${THREESCALE_SAAS_TENANT_NAME}-admin.3scale.net


oc new-app \
    -f https://raw.githubusercontent.com/3scale/3scale-amp-openshift-templates/2.0.0.GA/apicast-gateway/apicast.yml \
    -p RESPONSE_CODES=true \
    -p LOG_LEVEL=debug > /tmp/apicast_provision.txt

#optional staging
oc new-app \
    -f https://raw.githubusercontent.com/3scale/3scale-amp-openshift-templates/2.0.0.GA/apicast-gateway/apicast.yml \
    -p RESPONSE_CODES=true \
    -p DEPLOYMENT_ENVIRONMENT=sandbox \
    -p APICAST_NAME=apicast-staging \
    -p LOG_LEVEL=debug > /tmp/apicast_staging_provision.txt
