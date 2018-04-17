oc new-project bservices
oc project bservices
oc new-app docker.io/rhtgptetraining/wf_swarm_datestamp_service:1.0
 oc create route edge wfswarmdatestamproute --service=wfswarmdatestampservice
oc new-app docker.io/rhtgptetraining/vertx-greeting-service:1.0
 oc create route edge vertxgreetingroute --service=vertx-greeting-service
