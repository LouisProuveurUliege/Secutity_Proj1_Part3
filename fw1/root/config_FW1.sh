###### Rules for FW1 ######

iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Incoming traffic z-mail-ssh
iptables -A FORWARD -d 172.31.6.5 -p tcp --dport 993 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -d 172.31.6.5 -p tcp --dport 25 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -d 172.31.6.6 -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -d 172.31.6.0/24 -j DROP

# Outgoing traffic z-mail-ssh
iptables -A FORWARD -s 172.31.6.6 -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 172.31.6.5 -p tcp --dport 25 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 172.31.6.0/24 -j DROP

# Incoming traffic z-http
iptables -A FORWARD -d 172.31.5.0/24 -j DROP

# Outgoing traffic z-http 
iptables -A FORWARD -s 172.31.5.3 -p tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 172.31.5.3 -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 172.31.5.4 -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 172.31.5.4 -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 172.31.5.0/24 -j DROP

# Incoming traffic z-public
iptables -A FORWARD -d 172.32.5.2 -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -d 172.32.5.2 -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 172.31.6.6 -d 172.32.5.2 -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -d 172.32.5.3 -p tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -d 172.32.5.3 -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -d 172.32.5.0/24 -j DROP

# Outgoing traffic z-public
iptables -A FORWARD -s 172.32.5.3 -p tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 172.32.5.3 -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 172.32.5.0/24 -j DROP

# Deny by default
iptables -A FORWARD -j LOG --log-prefix "firewall 1"
iptables -A FORWARD -j DROP

# NAT Rules ======================================================

iptables -t nat -A PREROUTING -d 172.32.4.100 -p tcp --dport 22 -j DNAT --to-destination 172.31.6.6
iptables -t nat -A PREROUTING -d 172.32.4.100 -p tcp --dport 25 -j DNAT --to-destination 172.31.6.5
iptables -t nat -A PREROUTING -d 172.32.4.100 -p tcp --dport 993 -j DNAT --to-destination 172.31.6.5

iptables -t nat -A POSTROUTING -d 172.32.5.0/24 -j SNAT --to-source 172.32.5.1

iptables -t nat -A POSTROUTING -j SNAT --to-source 172.32.4.100

