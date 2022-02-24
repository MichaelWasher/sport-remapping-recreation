from scapy.all import *

interface='eth0'

# Get Ports
req_port = int(os.environ.get('REQUESTER_SERVICE_PORT'))
rec_port = int(os.environ.get('RECEIVER_SERVICE_PORT'))
print(f"Req Port: {req_port}")
print(f"Rec Port: {rec_port}")

# Get Service IPs
req_address = os.environ.get('REQUESTER_SERVICE_HOST')
rec_address = os.environ.get('RECEIVER_SERVICE_HOST')
print(f"Req Address: {req_address}")
print(f"Rec Address: {rec_address}")

# Send packet to Service
pkt=IP(dst=rec_address)/UDP(dport=rec_port, sport=req_port)/Raw(load="test 1")
print("--------------------------------------------------------------------")
print("Packet to Send")
print(pkt.display())
send(pkt, iface=interface)

# Expect to receive a packet to the same outgoing source
pkt_list=sniff(iface=interface, filter=f"udp and port {req_port}", count=1, timeout=5)

if len(pkt_list) < 1:
    print("No packets collected")
    exit(1)

pkt = pkt_list[0]
print("--------------------------------------------------------------------")
print("Packet recieved")
print(pkt.display())
