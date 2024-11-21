###### Rules for FW3 ######

iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT


# Incoming traffic z-drive
iptables -A FORWARD -s 192.168.3.2 -d 10.10.3.2 -p tcp --dport 445 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 192.168.3.3 -d 10.10.3.3 -p tcp --dport 873 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 192.168.3.3 -d 10.10.3.3 -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 10.10.4.6 -d 10.10.3.3 -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -d 10.10.3.0/24 -j DROP

# Outgoing traffic z-drive
iptables -A FORWARD -s 10.10.3.0/24 -j DROP

# Incoming traffic z-u3
iptables -A FORWARD -s 10.10.4.6 -d 192.168.3.2 -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -d 192.168.3.0/24 -j DROP

# Outgoing traffic z-u3
iptables -A FORWARD -s 192.168.3.3 -d 10.10.4.6 -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 192.168.3.0/24 -j DROP

# Incoming traffic z-ssh
iptables -A FORWARD -d 10.10.4.0/24 -j DROP

# Outgoing traffic z-ssh
iptables -A FORWARD -s 10.10.4.0/24 -j DROP

# Deny by default
iptables -A FORWARD -j LOG --log-prefix "Firewall 3"
iptables -A FORWARD -j DROP

