#!/bin/bash
set -x
# Add Resources
oc apply -f ./ns.yaml

oc project 03147725
oc apply -f svc.yaml
oc apply -f ./pod.yaml
sleep 2

# Copy files into Pods
oc cp receiver.py receiver:/
oc cp requester.py requester:/

sleep 2

# Run the Test
oc exec -t receiver -- python3 /receiver.py 2>&1 >receiver_logs &
oc exec -t requester -- python3 /requester.py 2>&1 >requester_logs