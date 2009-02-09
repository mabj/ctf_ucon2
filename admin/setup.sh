#!/bin/bash

MV="/bin/mv"
CAT="/bin/cat"
SED="/bin/sed"
ECHO="/bin/echo -e"
IPTABLES="/sbin/iptables"
ARP="/usr/sbin/arp -s"

# Check user permissions
WHOAMI=`/usr/bin/whoami`
if [ "${WHOAMI}" != "root" ]; then
  ${ECHO} "[+] This script needs to be run as root!"
  exit 1
fi

# Changing umask value (-rw-------)
${ECHO} "[+] Setting the appropriate umask..."
if [ -e /etc/profile.old ]; then
  ${MV} /etc/profile /etc/profile.old
  ${CAT} /etc/profile.old | ${SED} 's/umask\ 022/umask\ 177/' > /etc/profile
  # TODO: Verificar o impacto do .bash_profile no umask
fi

# Disabling ASLR into the linux kernel
${ECHO} "[+] Disabling stack-based addresses randomization..."
${ECHO} 0 > /proc/sys/kernel/randomize_va_space

# Prevent syslog from dumping messages to stdout
${ECHO} "[+] Defining syslog verbosity"
${ECHO} "4 1 1 7" > /proc/sys/kernel/printk

# Preventing ARP spoof
${ECHO} "[+] Setting up static MAC address..."
MACADDR="00:0C:29:76:BC:AC"
IPADDR=`/sbin/ifconfig eth0 | /bin/grep "inet addr" | /usr/bin/awk -F " " '{print $2}' | /usr/bin/awk -F ":" '{print $2}'`
${ARP} ${IPADDR} ${MACADDR}

# Setting local firewall configuration parameters
${ECHO} "[+] Configuring local firewall (iptables/netfilter based)..."
UCONADDR="69.56.251.150"
# TODO: ver para fazer com shellscript (cuidado com dnsspoof)
# TODO: ver para colocar o dnsspoof servindo o endereco da maquina ctfucon

# Additional security configuration parameters
${ECHO} "[+] Enabling firewall protection mechanisms..."
${ECHO} 0 > /proc/sys/net/ipv4/ip_forward
${ECHO} 0 > /proc/sys/net/ipv4/conf/all/accept_redirects
${ECHO} 0 > /proc/sys/net/ipv4/conf/all/accept_source_route
${ECHO} 1 > /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses
${ECHO} 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
${ECHO} 1 > /proc/sys/net/ipv4/tcp_syncookies

# Change default policies temporarily...
# Guarantee that the connection will be not dropped while the firewall rules are been applied
${ECHO} "[+] Setting temporary chain policies (remote setup)..."
${IPTABLES} -P INPUT ACCEPT
${IPTABLES} -P OUTPUT ACCEPT

${ECHO} "[+] Bringing firewall to ground zero..."
# Cleaning all firewall rules
${IPTABLES} -F
${IPTABLES} -t nat -F
${IPTABLES} -t mangle -F

# Cleaning all firewall chains
${IPTABLES} -X
${IPTABLES} -t nat -X
${IPTABLES} -t mangle -X

# Cleaning chain's counters
${IPTABLES} -Z
${IPTABLES} -t nat -Z
${IPTABLES} -t mangle -Z

# ACCEPTLOG chain
${ECHO} "[+] Creating ACCEPTLOG chain..."
${IPTABLES} -F ACCEPTLOG &>/dev/null
${IPTABLES} -X ACCEPTLOG &>/dev/null
${IPTABLES} -N ACCEPTLOG
${IPTABLES} -A ACCEPTLOG -m state --state NEW -j LOG --log-level 6 --log-prefix 'ACCEPT '
${IPTABLES} -A ACCEPTLOG -j ACCEPT

# DROPLOG chain
${ECHO} "[+] Creating DROPLOG chain..."
${IPTABLES} -F DROPLOG &>/dev/null
${IPTABLES} -X DROPLOG &>/dev/null
${IPTABLES} -N DROPLOG
${IPTABLES} -A DROPLOG -j LOG --log-level 6 --log-prefix 'DROP '
${IPTABLES} -A DROPLOG -j DROP

# TCP stateful inspection
${ECHO} "[+] Enabling stateful inspection..."

# INPUT chain
${IPTABLES} -A INPUT -m state --state INVALID -j DROPLOG
${IPTABLES} -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPTLOG

# OUTPUT chain
${IPTABLES} -A OUTPUT -m state --state INVALID -j DROPLOG
${IPTABLES} -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPTLOG

# Allow localhost connections
${ECHO} "[+] Allow localhost to localhost connections..."
${IPTABLES} -A INPUT -s 127.0.0.1/32 -d 127.0.0.1/32 -j ACCEPT
${IPTABLES} -A OUTPUT -s 127.0.0.1/32 -d 127.0.0.1/32 -j ACCEPT

# Firewall rules
${ECHO} "[+] Setting firewall rules..."
${IPTABLES} -A OUTPUT -s ${IPADDR}/32 -d ${UCONADDR}/32 -m owner --uid-owner root -p tcp --dport 25 -j ACCEPTLOG
${IPTABLES} -A OUTPUT -s ${IPADDR}/32 -d 0.0.0.0/0 -p icmp --icmp-type echo-request -j ACCEPTLOG
${IPTABLES} -A INPUT -s 0.0.0.0/0 -d ${IPADDR}/32 -p icmp --icmp-type echo-request -j ACCEPTLOG
${IPTABLES} -A INPUT -s 0.0.0.0/0 -d ${IPADDR}/32 -m multiport -p tcp --dports 22,23,80 -j ACCEPTLOG
${IPTABLES} -A INPUT -s 0.0.0.0/0 -m addrtype --dst-type BROADCAST -m multiport -p udp --dports 137,138 -j DROP

# so sai porta 25 se o usuario for o root
# habilita icmp echo request da maquina do CTF para todas outras maquinas da rede
# habilita icmp echo request para todas as maquinas da rede para a maquina do CTF
# permite conexoes nas portas 22,23,80 da maquina do CTF
# bloqueia mensagens NetBIOS para que nao fiquem registradas em log

# Catch all rules:
${ECHO} "[+] Defining cacth-all firewall rules..."
# any MaquinaCTF DROPLOG
${IPTABLES} -A INPUT -s 0.0.0.0/0 -d ${IPADDR}/32 -j DROPLOG
# MaquinaCTF any DROPLOG
${IPTABLES} -A OUTPUT -s ${IPADDR}/32 -d 0.0.0.0/0 -j DROPLOG

# Setting default policies back
${ECHO} "[+] Bringing back default policies state..."
${IPTABLES} -A INPUT -j DROPLOG
${IPTABLES} -P INPUT DROP
${IPTABLES} -A OUTPUT -j DROPLOG
${IPTABLES} -P OUTPUT DROP
${IPTABLES} -A FORWARD -j DROPLOG
${IPTABLES} -P FORWARD DROP
