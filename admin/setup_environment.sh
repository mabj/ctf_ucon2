#!/bin/bash
#
# setup_environment.sh is a piece of uCon 2009 Capture The Flag code
# Copyright (C) 2002 Marcos Alvares <marcos.alvares@gmail.com>
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3, or (at your option)
# any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#

MV="/bin/mv"
CAT="/bin/cat"
SED="/bin/sed"
ECHO="/bin/echo -e"
USERADD="/usr/sbin/useradd"
USERMOD="/usr/sbin/usermod"
IPTABLES="/sbin/iptables"
PING="/bin/ping -c1"
ARP="/usr/sbin/arp -s"
GROUPADD="/usr/sbin/groupadd"
ETHERNET_INTERFACE="eth0"
GREP='/bin/grep'

# Network informations
IPADDR=`/sbin/ifconfig ${ETHERNET_INTERFACE} | /bin/grep "inet addr" | /usr/bin/awk -F " " '{print $2}' | /usr/bin/awk -F ":" '{print $2}'`
MACADDR="00:0C:29:76:BC:AC"

add_challenges_users() {
  # Add challenge users
  ${ECHO} "[+] Adding challenge users..."
  for i in $(/usr/bin/seq -w 1 11); do
    ${USERADD} -u 10${i} challenge_${i} 2> /dev/null
    ${USERMOD} -d "" challenge_${i}
    ${USERMOD} -s "/bin/false" challenge_${i} 
  done
}

setting_global_profile_mask() {
  # Changing umask value (-rw-------)
  ${ECHO} "[+] Setting the appropriate umask..."
  if [ -e /etc/profile.old ]; then
    ${MV} /etc/profile /etc/profile.old
    ${CAT} /etc/profile.old | ${SED} 's/umask\ 022/umask\ 177/' > /etc/profile
    # TODO: Verificar o impacto do .bash_profile no umask
  fi
}

disable_stack_based_address_space_randomization() {
  # Disabling ASLR into the linux kernel
  ${ECHO} "[+] Disabling stack-based addresses randomization..."
  ${ECHO} 0 > /proc/sys/kernel/randomize_va_space
}

set_syslog_verbosity() {
  # Prevent syslog from dumping messages to stdout
  ${ECHO} "[+] Defining syslog verbosity..."
  ${ECHO} "4 1 1 7" > /proc/sys/kernel/printk
}

set_static_mac_address() {
  # Preventing ARP spoof
  ${ECHO} "[+] Setting up static MAC address..."
  GWADDR=`/sbin/route -n | /usr/bin/tail -1 | /usr/bin/awk '{print $2}'`
  ${PING} ${GWADDR} 2>&1>&/dev/null
  GWMAC=`/usr/sbin/arp -a ${GWADDR} | /usr/bin/awk '{print $4}'`
  ${ARP} ${GWADDR} ${GWMAC}
}


create_ctf_group() {
  ${ECHO} "[+] creating ctf administrative group"
  ${GROUPADD} ctf
}

set_fork_bomb_protection() {
  ${ECHO} "[+] Setting up the fork bomb protection"
  ULIMTS=`${CAT} /etc/security/limits.conf | ${GREP} ctf`
  if [ "${ULIMITS}" != "2" ]; then
    ${ECHO} "@ctf     hard     nproc    50" >> /etc/security/limits.conf
    ${ECHO} "@ctf     hard     cpu      2" >> /etc/security/limits.conf
  fi
}


###################### [MAIN CODE]
# Verify parameters and load external scripts

# Loading the firewall rules functions
. ./firewall-rules

# Check user permissions
WHOAMI=`/usr/bin/whoami`
if [ "${WHOAMI}" != "root" ]; then
  ${ECHO} "\n[!] This script needs to be run as root!\n"
  exit 1
fi

create_ctf_group
add_challenges_users
setting_global_profile_mask
disable_stack_based_address_space_randomization
set_syslog_verbosity
set_static_mac_address
setting_up_firewall_policies
set_fork_bomb_protection

${ECHO} "DONE ! \O/"
