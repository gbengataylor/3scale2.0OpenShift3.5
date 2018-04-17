oc new-project 3scale-amp
oc project 3scale-amp
#oc new-app --file amp.yml --param WILDCARD_DOMAIN=apps.18.221.137.63.nip.io --param ADMIN_PASSWORD=3scaleUser
oc new-app --file amp.yml --param WILDCARD_DOMAIN=apps.$EXTERNAL_IP.nip.io --param ADMIN_PASSWORD=3scaleUser

