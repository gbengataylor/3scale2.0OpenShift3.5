#delete existing routes
oc delete route api-apicast-production-route
oc delete route api-apicast-staging-route

#create production and staging routes for each service
#have -2- to avoid conflicts with hostnames since have multiple amps
export AMPNUM=2;
oc expose service apicast-production --name=swarm-apicast-production-route --hostname=swarm-3scale-$AMPNUM-apicast-production.$OCP_WILDCARD_DOMAIN
oc expose service apicast-staging --name=swarm-apicast-staging-route --hostname=swarm-3scale-$AMPNUM-apicast-staging.$OCP_WILDCARD_DOMAIN

oc expose service apicast-production --name=vertx-apicast-production-route --hostname=vertx-3scale-$AMPNUM-apicast-production.$OCP_WILDCARD_DOMAIN
oc expose service apicast-staging --name=vertx-apicast-staging-route --hostname=vertx-3scale-$AMPNUM-apicast-staging.$OCP_WILDCARD_DOMAIN
#for each one edit the route and add tls termination edge

#you will need to setup accounts, developers, services, application plans, applications in your on premise AMP
#note all these AMP setup can be done via the AMP Admin REST API
# to get endpoints to setup in on-premise AMP
echo -en "\n`oc get route swarm-apicast-production-route --template "https://{{.spec.host}}"`:443\n\n"

echo -en "\n`oc get route vertx-apicast-production-route --template "https://{{.spec.host}}"`:443\n\n"

#staging routes
echo -en "\n`oc get route swarm-apicast-staging-route --template "https://{{.spec.host}}"`:443\n\n"

echo -en "\n`oc get route vertx-apicast-staging-route --template "https://{{.spec.host}}"`:443\n\n"

#after making changes to SaaS AMP, you can wait a few minutes or force a rollout. you would need to promote to production
oc rollout latest apicast-production
#if you have apicast-staging and want to test before promoting to production, then rollout latest apicast-staging
oc rollout latest apicast-staging



# to test service call through the api cast
#SWARM_USER_KEY is the api key for the dev setup in SaaS AMP
#force an example here using an existing account for the swarm service
export SWARM_USER_KEY=4b3a338a9ca9cd909ebece63402769ca

echo $SWARM_USER_KEY
curl -v -k `echo -en "\nhttps://"$(oc get route/swarm-apicast-production-route -o template --template {{.spec.host}})"/time/now?user_key=$SWARM_USER_KEY\n"`
#stage test
curl -v -k `echo -en "\nhttps://"$(oc get route/swarm-apicast-staging-route -o template --template {{.spec.host}})"/time/now?user_key=$SWARM_USER_KEY\n"`

#vertx example
export VERTX_USER_KEY=b40f49505d2ae89f11bf27814fc9ed55

echo $VERTX_USER_KEY
curl -v -k `echo -en "\nhttps://"$(oc get route/vertx-apicast-production-route -o template --template {{.spec.host}})"/hello?user_key=$VERTX_USER_KEY\n"`
curl -v -k `echo -en "\nhttps://"$(oc get route/vertx-apicast-staging-route -o template --template {{.spec.host}})"/hello?user_key=$VERTX_USER_KEY\n"`


