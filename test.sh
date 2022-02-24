#!/bin/bash

# NOTE: There are sleeps in this to make sure that each application can finish starting before continuing. These may not be long enough and cause an issue, but just re-run this once the flow-rules have expired.

set -x
# Add Resources
oc apply -f ./ns.yaml

oc project 03147725
oc apply -f svc.yaml
oc apply -f ./colocated-pods.yaml

# Wait for Pods to be ready
while [[ $(kubectl get pods -l app=receiver -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for receiver pod" && sleep 1; done
while [[ $(kubectl get pods -l app=requester -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for requester pod" && sleep 1; done

# Copy files into Pods
oc cp receiver.py receiver:/
oc cp requester.py requester:/
sleep 2

# Run the Test
oc exec -t receiver -- python3 /receiver.py 2>&1 >receiver_logs &
sleep 2
oc exec -t requester -- python3 /requester.py 2>&1 >requester_logs
