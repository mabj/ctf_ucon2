#!/bin/bash

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
ECHO="/bin/echo -e"
SENDMAIL="./sendEmail-v1.55/sendEmail"

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

# Adding user ...
if [ -e "/home/${1}" ]; then
  ${ECHO} "\n[!] User [${1}] already exists!\n"
  exit 1
fi

${ECHO} "[+] Adding group ..."
${GROUPADD} ${1}

${ECHO} "[+] Adding user ..."
RANDPASS=`${PASSWORD}`
${USERADD} ${1} -d /home/${1} -m -g ${1} -p $(${OPENSSL} passwd -1 ${RANDPASS})
${CHMOD} -R 0700 /home/${1}

if [ -e ${WORKDIR} ]; then
  ${FIND} ${WORKDIR} -iname *.tag -exec ${CHATTR} -a {} \;
  ${FIND} ${WORKDIR} -iname *.tag -exec ${CHATTR} -i {} \;
  ${FIND} ${WORKDIR} -iname challen* -exec ${CHATTR} -a {} \;
  ${FIND} ${WORKDIR} -iname challen* -exec ${CHATTR} -i {} \;
  ${RM}
fi

${ECHO} "[+] cleanup workdir ... "
${RM} ${WORKDIR} 

${ECHO} "[+] Changing workdir privileges..."
${INSTALL} ${WORKDIR}
${CHOWN} ${1}.${1} ${WORKDIR}

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

# Copying workdir to the user home
${ECHO} "[+] Copying workdir to the users' home..."
${CP} ${WORKDIR} "/home/${1}"

# Changing directories permissions
${FIND} "/home/${1}" -iname *.c -exec ${CHOWN} ${1}.${1} {} \;

# Sending mail ...
IPADDR=`/sbin/ifconfig eth0 | /bin/grep "inet addr" | /usr/bin/awk -F " " '{print $2}' | /usr/bin/awk -F ":" '{print $2}'`

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
${ECHO} -n "Login: ${1}\nPassword: ${RANDPASS}\nCTF machine: ${IPADDR} [ctf.ucon-conference.org]\n\n" >> ${MAILDIR}${MESSAGE}
${ECHO} -n "Good Luck!!!\n\n--\nCTF Team @ uCon Security Conference 2009" >> ${MAILDIR}${MESSAGE}

if [ -e ./sendEmail-v1.55/sendEmail ]; then
  ${ECHO} "[+] Sending an email message with user credentials..."
  ${SENDMAIL} -f "${SENDER}" -u "${SUBJECT}" -t "${1} ${2}" -o message-file=${MAILDIR}${MESSAGE} -l ${MAILDIR}${LOGFILE} 2>&1>&/dev/null
else
  ${ECHO} "[!] Impossible to send user credentials through mail client..."
fi
