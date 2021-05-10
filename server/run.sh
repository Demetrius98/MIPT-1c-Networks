#!/bin/bash

ip link add ifb0 type ifb
ip link set ifb0 up
ip a

tc qdisc add dev eth0 ingress
tc filter add dev eth0 parent ffff: protocol ip u32 match u32 0 0 action mirred egress redirect dev ifb0
tc qdisc add dev ifb0 root handle 1:0 htb default 1
tc class add dev ifb0 parent 1:0 classid 1:1 htb rate 100mbit prio 1
tc filter add dev ifb0 protocol ip parent 1:0 prio 1 u32 match ip protocol 1 0xff action drop
tc filter add dev ifb0 protocol ip parent 1:0 prio 1 u32 match ip src 172.20.3.0/24 match ip protocol 6 0xff match ip dport 22 0xffff action drop


