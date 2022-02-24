from scapy.all import *
import time
import os


interface='eth0'
# collect values from packet
req_port = int(os.environ.get('REQUESTER_SERVICE_PORT'))
rec_port = int(os.environ.get('RECEIVER_SERVICE_PORT'))
print(f"Req Port: {req_port}")
print(f"Rec Port: {rec_port}")

# NOTE THIS should be the ServiceIP
req_address = os.environ.get('REQUESTER_SERVICE_HOST')
rec_address = os.environ.get('RECEIVER_SERVICE_HOST')
print(f"Req Address: {req_address}")
print(f"Rec Address: {rec_address}")


pkt_list=sniff(iface=interface, filter=f"udp and port {rec_port}", count=1)

if len(pkt_list) < 1:
    print("No packets collected")
    exit(1)

pkt = pkt_list[0]
print("Packet recieved")
print(pkt.display())

time.sleep(1)
pkt=IP(dst=req_address)/UDP(dport=req_port, sport=rec_port)/Raw(load="test 1")
print("Packet to Send")
print(pkt.display())


send(pkt, iface=interface)

