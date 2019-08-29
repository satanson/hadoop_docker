#!/bin/bash
iptables -D OUTPUT -p tcp -s 192.168.110.80 -d 192.168.110.40 --dport 2181 -j DROP
iptables -D OUTPUT -p tcp -s 192.168.110.80 -d 192.168.110.41 --dport 2181 -j DROP
iptables -D OUTPUT -p tcp -s 192.168.110.80 -d 192.168.110.42 --dport 2181 -j DROP
