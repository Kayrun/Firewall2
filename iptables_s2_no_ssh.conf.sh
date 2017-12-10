#!/bin/bash

#Flush tables and set policies to drop

iptables -F

iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

#Create Logging Chain for accepted packets on INPUT CHAIN

iptables -N accept-input

#Rules for  accept-input chain

iptables -A accept-input -j LOG --log-prefix "INPUT-ACCEPTED "
iptables -A accept-input -j ACCEPT

#Create Logging Chain for dropped packets on INPUT CHAIN

iptables -N drop-input

#Rules for  drop-input chain

iptables -A drop-input -j LOG --log-prefix "INPUT-DROPPED "
iptables -A drop-input -j DROP

#Create Logging Chain for accepted packets on OUTPUT CHAIN

iptables -N accept-output

#Rules for  accept-output chain

iptables -A accept-output -j LOG --log-prefix "OUTPUT-ACCEPTED "
iptables -A accept-output -j ACCEPT

#Create Logging Chain for dropped packets on OUTPUT CHAIN

iptables -N drop-output

#Rules for  drop-output chain

iptables -A drop-output -j LOG --log-prefix "OUTPUT-DROPPED "
iptables -A drop-output -j ACCEPT

#Create Logging Chain for accepted packets on FORWARD CHAIN

iptables -N accept-forward

#Rules for  accept-forward chain

iptables -A accept-forward -j LOG --log-prefix "FORWARD-ACCEPTED "
iptables -A accept-forward -j ACCEPT

#Create Logging Chain for dropped packets on FORWARD CHAIN

iptables -N drop-forward

#Rules for  drop-forward chain

iptables -A drop-forward -j LOG --log-prefix "FORWARD-DROPPED "
iptables -A drop-forward -j DROP

#Allow all directional pings

iptables -A INPUT -p icmp -s 195.165.26.0/25 -j accept-input
iptables -A OUTPUT -p icmp -s 195.165.26.0/25 -j accept-output
iptables -A FORWARD -p icmp -s 195.165.26.0/25 -j accept-forward


#Allow SCP from client to Linux server

iptables -A FORWARD -p tcp -s 195.165.26.0/25 --dport 2323 -m state --state NEW,ESTABLISHED,RELATED -j accept-forward
iptables -A FORWARD -p tcp -s 195.165.26.0/25 -d 195.165.26.0/25 --sport 2323 -m state --state ESTABLISHED,RELATED -j accept-forward

#Allow Apache access throughout the 195.165.26.0/25 network space

iptabes -A FORWARD -p tcp -s 195.165.26.0/25 -d 195.165.26.0/25 --dport 8585 -m state --state NEW,ESTABLISHED,RELATED -j accept-forward
iptabes -A FORWARD -p tcp -s 195.165.26.0/25 -d 195.165.26.0/25 --sport 8585 -m state --state ESTABLISHED,RELATED -j accept-forward

#Allow Apache access throughout the 195.165.0.0/18 network space

iptables -A FORWARD -p tcp -s 195.165.0.0/18 -d 195.165.26.0/18 --dport 8585 -m state --state NEW,ESTABLISHED,RELATED -j accept-forward
iptables -A FORWARD -p tcp -s 195.165.0.0/18 -d 195.165.26.0/18 --sport 8585 -m state --state ESTABLISHED,RELATED -j accept-forward

#Allow IIS access throughout the 195.165.26.0/25 network space

iptabes -A FORWARD -p tcp -s 195.165.26.0/25 -d 195.165.26.0/25 --dport 9595 -m state --state NEW,ESTABLISHED,RELATED -j accept-forward
iptabes -A FORWARD -p tcp -s 195.165.26.0/25 -d 195.165.26.0/25 --sport 9595 -m state --state ESTABLISHED,RELATED -j accept-forward

#Allow IIS access throughout the 195.165.0.0/18 network space

iptables -A FORWARD -p tcp -s 195.165.0.0/18 -d 195.165.26.0/18 --dport 9595 -m state --state NEW,ESTABLISHED,RELATED -j accept-forward
iptables -A FORWARD -p tcp -s 195.165.0.0/18 -d 195.165.26.0/18 --sport 9595 -m state --state ESTABLISHED,RELATED -j accept-forward

#Allow MySQL database connection from client to Win-server

iptables -A FORWARD -p tcp -s 195.165.26.0/25 -d 195.165.26.0/25 --dport 3306 -m state --state NEW,ESTABLISHED,RELATED -j accept-forward
iptables -A FORWARD -p tcp -s 195.165.26.0/25 -d 195.165.26.0/25 --sport 3306 -m state --state ESTABLISHED,RELATED -j accept-forward

#Allow E-mails from client to Win-server

  #SMTP
  iptables -A FORWARD -p tcp -s 195.165.26.0/25 -d 195.165.26.0/25 --dport 25 -m state --state NEW,ESTABLISHED,RELATED -j accept-forward
  iptables -A FORWARD -p tcp -s 195.165.26.0/25 -d 195.165.26.0/25 --sport 25 -m state --state ESTABLISHED,RELATED -j accept-forward

  #IMAP
  iptables -A FORWARD -p tcp -s 195.165.26.0/25 -d 195.165.26.0/25 --dport 143 -m state --state NEW,ESTABLISHED,RELATED -j accept-forward
  iptables -A FORWARD -p tcp -s 195.165.26.0/25 -d 195.165.26.0/25 --sport 143 -m state --state ESTABLISHED,RELATED -j accept-forward

#Allow FTP (not encrypted) connection from client to Win-server

iptables -A FORWARD -p tcp -s 195.165.26.0/25 -d 195.165.26.0/25 --dport 21 -m state --state NEW,ESTABLISHED,RELATED -j accept-forward
iptables -A FORWARD -p tcp -s 195.165.26.0/25 -d 195.165.26.0/25 --sport 21 -m state --state ESTABLISHED,RELATED -j accept-forward
iptables -A FORWARD -p tcp -s 195.165.26.0/25 -d 195.165.26.0/25 --sport 20 -m state --state ESTABLISHED,RELATED -j accept-forward

  #Passive FTP
  iptables -A FORWARD -p tcp -s 195.165.26.0/25 -d 195.165.26.0/25 --dport 5500:5525 -j accept-forward
  iptables -A FORWARD -p tcp -s 195.165.26.0/25 -d 195.165.26.0/25 --sport 5500:5525 -j accept-forward


#Allow DNS traffic within the network

iptables -A FORWARD -p tcp -s 195.165.26.0/25 -d 195.165.26.0/25 --dport 53  -j accept-forward
iptables -A FORWARD -p tcp -s 195.165.26.0/25 -d 195.165.26.0/25 --sport 53  -j accept-forward

iptables -A FORWARD -p udp -s 195.165.26.0/25 -d 195.165.26.0/25 --dport 53  -j accept-forward
iptables -A FORWARD -p udp -s 195.165.26.0/25 -d 195.165.26.0/25 --sport 53  -j accept-forward

iptables -A INPUT -p udp -s 195.165.26.0/25 -d 195.165.26.0/25 --sport 53  -j accept-input
iptables -A OUTPUT -p udp -s 195.165.26.0/25 -d 195.165.26.0/25 --dport 53  -j accept-output

#Allow DHCP traffic between the client and the windows server

iptables -A INPUT -p udp -s 195.165.26.0/25 -d 195.165.26.0/25 --dport 67  -j accept-input
iptables -A OUTPUT -p udp -s 195.165.26.0/25 -d 195.165.26.0/25 --sport 67  -j accept-output

iptables -A FORWARD -p udp -s 195.165.26.0/25 -d 195.165.26.0/25 --dport 67  -j accept-forward
iptables -A FORWARD -p udp -s 195.165.26.0/25 -d 195.165.26.0/25 --sport 67  -j accept-forward

#Log all DROPPED traffic

iptables -A INPUT -j drop-input
iptables -A OUTPUT -j drop-output
iptables -A FORWARD -j drop-forward

iptables -L -n
