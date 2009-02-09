#!/bin/bash

RM="/bin/rm -rf"
ECHO="/bin/echo -e"
USERDEL="/usr/sbin/userdel"
CHATTR="/usr/bin/chattr"

if [ $# != 1 ]; then
	echo -e ".:: uCon 2 Capture The Flag ::.\n"
	echo -e "   Usage: ${0} [user_name]\n"
	exit 1
fi

if [ ! -e "/home/${1}" ]; then
  ${ECHO} "\n[!] User [${1}] not exists!\n"
  exit 1
fi

WHOAMI=`/usr/bin/whoami`
if [ "${WHOAMI}" != "root" ]; then
  ${ECHO} "[+] This script needs to be run as root!"
  exit 1
fi

${ECHO} "[+] Removing file attributes..."

for i in $(seq 1 5); do
  ${CHATTR} -i "/home/${1}/ucon2/crackme/challenge_0${i}/challenge_0${i}"
  ${CHATTR} -a "/home/${1}/ucon2/crackme/challenge_0${i}/challenge_0${i}.tag"
done

for i in $(seq -w 6 11); do
  ${CHATTR} -i 	"/home/${1}/ucon2/vulndev/challenge_${i}/challenge_${i}"
  ${CHATTR} -a 	"/home/${1}/ucon2/vulndev/challenge_${i}/challenge_${i}.tag"
done

${ECHO} "[+] Removing users' home directory..."
${RM} "/home/${1}"
${ECHO} "[+] Removing user registry..."
${USERDEL} ${1}
