#!/bin/bash

set -x
# Add Resources
oc apply -f ./ns.yaml

oc project 03147725
oc apply -f svc.yaml
oc apply -f ./colocated-pods.yaml
oc apply -f ./collector-pod.yaml

# Wait for Pods to be ready
while [[ $(kubectl get pods -l app=receiver -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for receiver pod" && sleep 1; done
while [[ $(kubectl get pods -l app=requester -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for requester pod" && sleep 1; done
