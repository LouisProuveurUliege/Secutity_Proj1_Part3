###### Rules for FW1 ######
-A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Incoming traffic z-mail-ssh
iptables -A FORWARD -d 172.31.6.5 -p tcp --dport 993 -j ACCEPT
iptables -A FORWARD -d 172.31.6.5 -p tcp --dport 25 -j ACCEPT
iptables -A FORWARD -d 172.31.6.6 -p tcp --dport 22 -j ACCEPT
iptables -A FORWARD -d 172.31.6.0/24 -j DROP

# Outgoing traffic z-mail-ssh
iptables -A FORWARD -s 173.31.6.6 -p tcp --dport 22 -j ACCEPT
iptables -A FORWARD -s 173.31.6.5 -p tcp --dport 25 -j ACCEPT
iptables -A FORWARD -s 172.31.6.0/24 -j DROP

# Incoming traffic z-http
iptables -A FORWARD -d 172.31.5.0/24 -j DROP

# Outgoing traffic z-http 
iptables -A FORWARD -s 172.31.5.3 -p tcp --dport 53 -j ACCEPT
iptables -A FORWARD -s 172.31.5.3 -p udp --dport 53 -j ACCEPT
iptables -A FORWARD -s 172.31.5.4 -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -s 172.31.5.4 -p tcp --dport 443 -j ACCEPT
iptables -A FORWARD -s 172.31.5.0/24 -j DROP

# Incoming traffic z-public
iptables -A FORWARD -d 172.32.5.2 -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -d 172.32.5.2 -p tcp --dport 443 -j ACCEPT
iptables -A FORWARD -s 172.31.6.6 -d 172.32.5.2 -p tcp --dport 22 -j ACCEPT
iptables -A FORWARD -d 172.32.5.3 -p tcp --dport 53 -j ACCEPT
iptables -A FORWARD -d 172.32.5.3 -p udp --dport 53 -j ACCEPT
iptables -A FORWARD -d 172.32.5.0/24 -j DROP

# Outgoing traffic z-public
iptables -A FORWARD -s 172.32.5.3 -p tcp --dport 53 -j ACCEPT
iptables -A FORWARD -s 172.32.5.3 -p udp --dport 53 -j ACCEPT
iptables -A FORWARD -s 172.32.5.0/24 -j DROP

# Deny by default
iptables -A FORWARD -j LOG --log-prefix "firewall 1"
iptables -A FORWARD -j DROP

# NAT Rules ======================================================

iptables -t nat -A PREROUTING -d 172.32.4.100 -p tcp --dport 22 -j DNAT --to-destination 172.31.6.6
iptables -t nat -A PREROUTING -d 172.32.4.100 -p tcp --dport 25 -j DNAT --to-destination 172.31.6.5
iptables -t nat -A PREROUTING -d 172.32.4.100 -p tcp --dport 993 -j DNAT --to-destination 172.31.6.5

