# Connection Tracking and Service Remapping Tester Tool


For basic usage, try running the `./test.sh` against your cluster.

This will run a single bi-directional UDP 'stream' of traffic between 2 endpoints (service-to-service). 
Upon receiving a packet, the application will respond, so inflight packets should max at 1.

After a packet is lost or delayed, a timer will count up to 10 and if `reinit` is set, the requester endpoint will send another datagram in an attempt to re trigger the back-and-forth connection.


``` bash
|main⚡ ⇒ python3 ./main.py --help
usage: main.py [-h] [--req-port Req_P] [--rec-port Rec_P] [--req-address Req_Addr] [--rec-address Rec_Addr] [--conn-end Conn_End] [--protocol Protocol] [--reinit | --no-reinit]

Performing testing and reproduction of issues seen in OVNKubernetes connection tracking.

optional arguments:
  -h, --help            show this help message and exit
  --req-port Req_P      the source port for request packets. Defaults to env `REQUESTER_SERVICE_PORT`
  --rec-port Rec_P      the source port for receiver Pods packets. Defaults to env `RECEIVER_SERVICE_PORT`
  --req-address Req_Addr
                        the source IP addres for request packets. Defaults to env `REQUESTER_SERVICE_HOST`
  --rec-address Rec_Addr
                        the source IP addres for receiver packets. Defaults to env `RECEIVER_SERVICE_HOST`
  --conn-end Conn_End   Whether the application should initiate the communication or wait to be initiated with. Options are "receiver" or "requester"
  --protocol Protocol   The L4 protocol to be used with tests. Options are "udp" or "tcp"
  --reinit, --no-reinit
                        Re-initialise communication after context-timeout. This is only used if conn-end is "requester" (default: True)
```