#!/bin/bash
#
# create_user.sh is a piece of uCon 2009 Capture The Flag code
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

GCC="/usr/bin/gcc -fno-stack-protector -ggdb -o "
MAKE="/usr/bin/make"
INSTALL="/usr/bin/install -d"
FIND="/usr/bin/find"
RM="/bin/rm -rf"
WORKDIR="./ucon2"
CP="/bin/cp -af"
CAT="/bin/cat"
CHOWN="/bin/chown"
CHMOD="/bin/chmod"
CHATTR="/usr/bin/chattr"
TOUCH="/usr/bin/touch"
OPENSSL="/usr/bin/openssl"
PASSWORD="${OPENSSL} rand -base64 8"
USERADD="/usr/sbin/useradd"
GROUPADD="/usr/sbin/groupadd"
ADDGROUP="/usr/sbin/addgroup"
ECHO="/bin/echo -e"
SENDMAIL="./sendEmail-v1.55/sendEmail"
ETHERNET_INTERFACE="eth0"
SETQUOTA="/usr/sbin/setquota -u"
HOME_DEVICE="/dev/sda6"
TMP_DEVICE="/dev/sda5"
VAR_DEVICE="/dev/sda2"
ROOT_DEVICE="/dev/sda1"

# setquota -u mabj 10000 10000 0 0 -f /dev/sda6
add_user_and_group() {
  # Adding user and group ...
  ${ECHO} "[+] Adding group ${1}..."
  ${GROUPADD} ${1}

  ${ECHO} "[+] Adding user ${1}..."
  RANDPASS=`${PASSWORD}`
  ${USERADD} ${1} -d /home/${1} -s /bin/bash -m -g ${1} -p $(${OPENSSL} passwd -1 ${RANDPASS})
  
  ${ECHO} "[+] Adding user ${1} to administrative group ctf ..."
  ${ADDGROUP} ${1} ctf >> /dev/null
  ${CHMOD} -R 0700 /home/${1}
  ${SETQUOTA} ${1} 10000 10000 0 0 -f ${HOME_DEVICE}
  ${SETQUOTA} ${1} 1000 1000 0 0 -f ${TMP_DEVICE}
  ${SETQUOTA} ${1} 1 1 0 0 -f ${VAR_DEVICE}
  ${SETQUOTA} ${1} 1 1 0 0 -f ${ROOT_DEVICE}
  sending_user_password_mail ${1} ${2} ${RANDPASS}
}

cleanup_workdir() {
  ${ECHO} "[+] cleanup workdir ... "
  if [ -e ${WORKDIR} ]; then
    ${FIND} ${WORKDIR} -iname *.tag -exec ${CHATTR} -a {} \;
    ${FIND} ${WORKDIR} -iname *.tag -exec ${CHATTR} -i {} \;
    ${FIND} ${WORKDIR} -iname challen* -exec ${CHATTR} -a {} \;
    ${FIND} ${WORKDIR} -iname challen* -exec ${CHATTR} -i {} \;
    ${RM}
  fi

  ${RM} ${WORKDIR} 
}

create_workdir() {
  ${ECHO} "[+] Changing workdir privileges..."
  ${INSTALL} ${WORKDIR}
  ${CHOWN} ${1}.${1} ${WORKDIR}
}

build_crackme_challenges() {
  # Build crackme challenges
  ${ECHO} "[+] Building crackme challenges ..."
  for i in $(/bin/ls ./code/crackme/*.c) ; do
    # Create challenge directory
    PROGRAM=`/bin/echo $i | /usr/bin/awk -F "/" '{print $4}' | /usr/bin/awk -F "." '{print $1}'`
    ${INSTALL} "${WORKDIR}/crackme/${PROGRAM}"
    # Define challenge directory permissions
    ${CHOWN} ${1}.${1} "${WORKDIR}/crackme"
    ${CHOWN} -R ${1}.${1} "${WORKDIR}/crackme/${PROGRAM}"
    # Compile challenge and configure its permissions
    ${GCC} "${WORKDIR}/crackme/${PROGRAM}/${PROGRAM}" ${i}
    ${CHOWN} ${PROGRAM}.${PROGRAM} "${WORKDIR}/crackme/${PROGRAM}/${PROGRAM}"
    ${CHMOD} 4555 "${WORKDIR}/crackme/${PROGRAM}/${PROGRAM}"
    ${CHATTR} +i "${WORKDIR}/crackme/${PROGRAM}/${PROGRAM}"
    # Create the challenge tag file
    ${TOUCH} "${WORKDIR}/crackme/${PROGRAM}/${PROGRAM}.tag"
    ${CHOWN} ${PROGRAM}.${PROGRAM} "${WORKDIR}/crackme/${PROGRAM}/${PROGRAM}.tag"
    ${CHMOD} 0600 "${WORKDIR}/crackme/${PROGRAM}/${PROGRAM}.tag"
    ${CHATTR} +a "${WORKDIR}/crackme/${PROGRAM}/${PROGRAM}.tag"
  done
}

build_vulndev_challenges() {
  # Build vulndev challenges
  ${ECHO} "[+] Building vulndev challenges ..."
  for i in $(/bin/ls ./code/vulndev/*.c) ; do
    # Create challenge directory
    PROGRAM=`/bin/echo $i | /usr/bin/awk -F "/" '{print $4}' | /usr/bin/awk -F "." '{print $1}'`
    ${INSTALL} "${WORKDIR}/vulndev/${PROGRAM}"
    # Define challenge directory permissions
    ${CHOWN} ${1}.${1} "${WORKDIR}/vulndev"
    ${CHOWN} -R ${1}.${1} "${WORKDIR}/vulndev/${PROGRAM}"
    # Compile challenge and configure its permissions
    ${GCC} "${WORKDIR}/vulndev/${PROGRAM}/${PROGRAM}" ${i}
    ${CP} ${i} "${WORKDIR}/vulndev/$PROGRAM/"
    ${CHOWN} ${PROGRAM}.${PROGRAM} "${WORKDIR}/vulndev/${PROGRAM}/${PROGRAM}"
    ${CHMOD} 4555 "${WORKDIR}/vulndev/${PROGRAM}/${PROGRAM}"
    ${CHATTR} +i "${WORKDIR}/vulndev/${PROGRAM}/${PROGRAM}"
    # Create the challenge tag file
    ${TOUCH} "${WORKDIR}/vulndev/${PROGRAM}/${PROGRAM}.tag"
    ${CHOWN} ${PROGRAM}.${PROGRAM} "${WORKDIR}/vulndev/${PROGRAM}/${PROGRAM}.tag"
    ${CHMOD} 0600 "${WORKDIR}/vulndev/${PROGRAM}/${PROGRAM}.tag"
    ${CHATTR} +a "${WORKDIR}/vulndev/${PROGRAM}/${PROGRAM}.tag"
  done
}

change_user_home_permissions() {
  # Changing directories permissions
  ${FIND} "/home/${1}" -iname *.c -exec ${CHOWN} ${1}.${1} {} \;
}

copy_workdir_to_user_home() {
  # Copying workdir to the user home
  ${ECHO} "[+] Copying workdir to the users' home..."
  ${CP} ${WORKDIR} "/home/${1}"
  change_user_home_permissions ${1}
}

sending_user_password_mail() {
  # Sending mail ...
  IPADDR=`/sbin/ifconfig ${ETHERNET_INTERFACE} | /bin/grep "inet addr" | /usr/bin/awk -F " " '{print $2}' | /usr/bin/awk -F ":" '{print $2}'`

  MAILDIR="./users/${1}/mail/"
  if [ ! -d "${MAILDIR}" ]; then
    ${INSTALL} ${MAILDIR}
  fi

  LOGFILE="mail.log"
  MESSAGE="message.txt"

  SENDER="CTF @ uCon 2009 <ctf@ucon-conference.org>"
  SUBJECT="Registration: uCon CTF - 2009 edition"

  ${ECHO} -n "Congratulations ${1}, you have been subscribed to the uCon Capture The Flag 2009 edition. " > ${MAILDIR}${MESSAGE}
  ${ECHO} -n "You should SSH the CTF machine in order to change the default password.\n\n" >> ${MAILDIR}${MESSAGE}
  ${ECHO} -n "Following up are user's credentials:\n\n" >> ${MAILDIR}${MESSAGE}
  ${ECHO} -n "Login: ${1}\nPassword: ${3}\nCTF machine: ${IPADDR} [ctf.ucon-conference.org]\n\n" >> ${MAILDIR}${MESSAGE}
  ${ECHO} -n "Good Luck!!!\n\n--\nCTF Team @ uCon Security Conference 2009" >> ${MAILDIR}${MESSAGE}

  if [ -e ./sendEmail-v1.55/sendEmail ]; then
    ${ECHO} "[+] Sending an email message with user credentials..."
    ${SENDMAIL} -f "${SENDER}" -u "${SUBJECT}" -t "${1} ${2}" -o message-file=${MAILDIR}${MESSAGE} -l ${MAILDIR}${LOGFILE} 2>&1>&/dev/null
  else
    ${ECHO} "[!] Impossible to send user credentials through mail client..."
  fi
}


###################### [MAIN CODE]

# checking parameters and environment before add the user
# Verify parameters
if [ $# != 2 ]; then
  ${ECHO} ".:: uCon 2 Capture The Flag ::.\n"
  ${ECHO} "   Usage: ${0} [user_name] [user_mail]\n"
  exit 1
fi

# Check user permissions
WHOAMI=`/usr/bin/whoami`
if [ "${WHOAMI}" != "root" ]; then
  ${ECHO} "\n[!] This script needs to be run as root!\n"
  exit 1
fi

if [ -e "/home/${1}" ]; then
  ${ECHO} "\n[!] User [${1}] already exists!\n"
  exit 1
fi

add_user_and_group ${1} ${2}
cleanup_workdir
create_workdir ${1}
build_crackme_challenges ${1}
build_vulndev_challenges ${1}
copy_workdir_to_user_home ${1}
cleanup_workdir

${ECHO} "DONE ! \O/"
