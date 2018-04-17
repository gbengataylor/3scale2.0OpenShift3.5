oc expose service apicast \
     -l app=3scale-gateway \
     --name=swarm-apicast-route \
     --hostname=swarm-3scale-apicast.$OCP_WILDCARD_DOMAIN

oc expose service apicast \
     -l app=3scale-gateway \
     --name=vertx-apicast-route \
     --hostname=vertx-3scale-apicast.$OCP_WILDCARD_DOMAIN
#need to edit the route to add edge termination for both
#  tls:
#    termination: edge

# note: if you need to add staging routes, need to put up a new apicast-staging app/service, then set the DEPLOYMENT_ENVIRONMENT=sandbox (and APICAST_NAME)
# and then create routes for each service
# you can use the staging routes in the staing url in the AMP SaaS
oc expose service apicast-staging \
     -l app=3scale-gateway \
     --name=swarm-apicast-staging-route \
     --hostname=swarm-3scale-apicast-staging.$OCP_WILDCARD_DOMAIN

oc expose service apicast-staging \
     -l app=3scale-gateway \
     --name=vertx-apicast-staging-route \
     --hostname=vertx-3scale-apicast-staging.$OCP_WILDCARD_DOMAIN

#you will need to setup accounts, developers, services, application plans, applications in your on premise AMP
#note all these AMP setup can be done via the AMP Admin REST API
# to get endpoints to setup in SaaS AMP
echo -en "\n`oc get route swarm-apicast-route --template "https://{{.spec.host}}"`:443\n\n"

echo -en "\n`oc get route vertx-apicast-route --template "https://{{.spec.host}}"`:443\n\n"

#staging routes
echo -en "\n`oc get route swarm-apicast-staging-route --template "https://{{.spec.host}}"`:443\n\n"

echo -en "\n`oc get route vertx-apicast-staging-route --template "https://{{.spec.host}}"`:443\n\n"

#after making changes to SaaS AMP, you can wait a few minutes or force a rollout. you would need to promote to production
oc rollout latest apicast

#if you have apicast-staging and want to test before promoting to production, then rollout latest apicast-staging


# to test service call through the api cast
#SWARM_USER_KEY is the api key for the dev setup in SaaS AMP
#force an example here using an existing account for the swarm service
export SWARM_USER_KEY=54c22412c829396af6746c134209e6ba   

ech o$SWARM_USER_KEY
curl -v -k `echo -en "\nhttps://"$(oc get route/swarm-apicast-route -o template --template {{.spec.host}})"/time/now?user_key=$SWARM_USER_KEY\n"`
#stage test
curl -v -k `echo -en "\nhttps://"$(oc get route/swarm-apicast-staging-route -o template --template {{.spec.host}})"/time/now?user_key=$SWARM_USER_KEY\n"`

#vertx example
export VERTX_USER_KEY=c3172142e59c50da6debc70da1a09574

echo $VERTX_USER_KEY
curl -v -k `echo -en "\nhttps://"$(oc get route/vertx-apicast-route -o template --template {{.spec.host}})"/hello?user_key=$VERTX_USER_KEY\n"`
curl -v -k `echo -en "\nhttps://"$(oc get route/vertx-apicast-staging-route -o template --template {{.spec.host}})"/hello?user_key=$VERTX_USER_KEY\n"`
