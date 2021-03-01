#!/bin/sh -e

iptables -A INPUT -i lo -j ACCEPT

iptables -A INPUT -s 192.168.0.0/24 -j ACCEPT

iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#iptables -A INPUT -i eth0:0 -p tcp -s 192.168.132.0/17 --dport 1337 -j ACCEPT

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

iptables -L -n

exit 0
