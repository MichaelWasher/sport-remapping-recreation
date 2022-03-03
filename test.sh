#!/bin/bash

# NOTE: There are sleeps in this to make sure that each application can finish starting before continuing. These may not be long enough and cause an issue, but just re-run this once the flow-rules have expired.

set -x

term() {
    echo "Cancelling test..."
    pkill -P $$
    
    source ./kill.sh

    # Copy results back
    oc cp receiver:/receiver_logs receiver_logs
    oc cp requester:/requester_logs requester_logs

    exit 1
}
trap term SIGTERM SIGINT

# Add Resources
source ./setup.sh


# Copy files into Pods
oc cp main.py receiver:/receiver.py
oc cp main.py requester:/requester.py

# Run the Test
oc exec -t receiver -- sh -c "python3 -u /receiver.py --conn-end='receiver' 2>&1 >receiver_logs" &
sleep 2
oc exec -t requester -- sh -c "python3 -u /requester.py --no-reinit 2>&1 >requester_logs" 

# Copy results back
oc cp receiver:/receiver_logs receiver_logs
oc cp requester:/requester_logs requester_logs
