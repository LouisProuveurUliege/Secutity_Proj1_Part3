###### Rules for FW2 ######

# Flush existing rules
iptables -F
iptables -X

iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT


# Incoming traffic z-lweb
iptables -A FORWARD -s 192.168.1.0/24 -d 10.10.2.2 -p tcp --dport 21 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 192.168.1.0/24 -d 10.10.2.2 -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 192.168.2.0/24 -d 10.10.2.2 -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -d 10.10.2.0/24 -j DROP

# Outgoing traffic z-lweb
iptables -A FORWARD -s 10.10.2.0/24 -j DROP

# Incoming traffic z-u1
iptables -A FORWARD -s 10.10.1.6 -d 192.168.1.0/24 -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -d 192.168.1.0/24 -j DROP

# Outgoing traffic z-u1
iptables -A FORWARD -s 192.168.1.0/24 -d 10.10.1.4 -p tcp --dport 3128 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 192.168.1.0/24 -d 10.10.1.3 -p tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 192.168.1.0/24 -d 10.10.1.3 -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 192.168.1.0/24 -d 10.10.1.5 -p tcp --dport 25 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 192.168.1.0/24 -d 10.10.1.5 -p tcp --dport 143 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 192.168.1.0/24 -d 10.10.1.5 -p tcp --dport 993 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 192.168.1.0/24 -d 10.10.1.6 -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 192.168.1.2 -d 10.10.1.2 -p udp --dport 67 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 192.168.1.0/24 -j DROP

# Incoming traffic z-u2
iptables -A FORWARD -s 10.10.1.6 -d 192.168.2.0/24 -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -d 192.168.2.0/24 -j DROP

# Outgoing traffic z-u2
iptables -A FORWARD -s 192.168.2.0/24 -d 10.10.1.4 -p tcp --dport 3128 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 192.168.2.0/24 -d 10.10.1.3 -p tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 192.168.2.0/24 -d 10.10.1.3 -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 192.168.2.0/24 -d 10.10.1.5 -p tcp --dport 25 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 192.168.2.0/24 -d 10.10.1.5 -p tcp --dport 143 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 192.168.2.0/24 -d 10.10.1.5 -p tcp --dport 993 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 192.168.2.2 -d 10.10.1.2 -p udp --dport 67 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 192.168.2.0/24 -j DROP

# Incoming traffic z-all-sandwich
iptables -A FORWARD -d 10.10.1.0/24 -j DROP

# Outgoing traffic z-all-sandwich
iptables -A FORWARD -s 10.10.1.0/24 -j DROP

# Default rules
iptables -A FORWARD -j LOG --log-prefix "firewall 2: "
iptables -A FORWARD -j DROP
