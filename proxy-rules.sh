#!/bin/bash
set -e

PROXY_IP=172.24.16.48
BACKEND_IP=172.24.16.156

#удадение существующих правил

iptables -F
iptables -X

#дроп
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

#разрешить лупбек
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

#разрешить текущие соединения
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

#разрешить ссш
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT

#разрешить icmp
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT

#разрешить днс
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT

#доступ к прокси
iptables -A INPUT -p tcp --dport 5000 -j ACCEPT

#доступ с прокси к бекенду
iptables -A OUTPUT -p tcp -d $BACKEND_IP --dport 8080 -j ACCEPT

#локальный доступ с прокси до редиса
iptables -A OUTPUT -p tcp -d 127.0.0.1 --dport 6379 -j ACCEPT

echo "GOTOVO - PROXY"
