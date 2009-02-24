#!/bin/bash
#
# remove_user.sh is a piece of uCon 2009 Capture The Flag code
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

RM="/bin/rm -rf"
ECHO="/bin/echo -e"
USERDEL="/usr/sbin/userdel"
CHATTR="/usr/bin/chattr"

remove_user_home_attributes() {
  ${ECHO} "[+] Removing file attributes..."

  for i in $(seq 1 5); do
    ${CHATTR} -i "/home/${1}/ucon2/crackme/challenge_0${i}/challenge_0${i}"
    ${CHATTR} -a "/home/${1}/ucon2/crackme/challenge_0${i}/challenge_0${i}.tag"
  done

  for i in $(seq -w 6 11); do
    ${CHATTR} -i  "/home/${1}/ucon2/vulndev/challenge_${i}/challenge_${i}"
    ${CHATTR} -a  "/home/${1}/ucon2/vulndev/challenge_${i}/challenge_${i}.tag"
  done
}

remove_user_home_directory() {
  ${ECHO} "[+] Removing users' home directory..."
  ${RM} "/home/${1}"
}

remove_user() {
  remove_user_home_directory $1
  ${ECHO} "[+] Removing user registry..."
  ${USERDEL} ${1}
}

###################### [MAIN CODE]

# checking parameters and environment before delete the user
if [ $# != 1 ]; then
  ${ECHO} ".:: uCon 2 Capture The Flag ::.\n"
  ${ECHO} "   Usage: ${0} [user_name]\n"
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

remove_user_home_attributes $1
remove_user $1

${ECHO} "DONE ! \O/"
