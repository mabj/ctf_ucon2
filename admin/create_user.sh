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
USERMOD="/usr/sbin/usermod"
ECHO="/bin/echo -e"
SENDMAIL="./sendEmail-v1.55/sendEmail \
         -f \"CTF - uCon Security Conference <ctf@ucon-conference.org>\" \
         -u \"uCon CTF - 2009 edition\""

# Verify parameters
if [ $# != 2 ]; then
  ${ECHO} ".:: uCon 2 Capture The Flag ::.\n"
  ${ECHO} "   Usage: ${0} [user_name] [user_mail]\n"
  exit 1
fi

# Check user permissions
WHOAMI=`/usr/bin/whoami`
if [ "${WHOAMI}" != "root" ]; then
  ${ECHO} "[+] This script needs to be run as root!"
  exit 1
fi

if [ -e "/home/${1}" ]; then
	${ECHO} "\n[!] User [${1}] already exists!\n"
	exit 1
fi

# Add challenge users
for i in $(seq -w 1 11); do
	${USERADD} -u 10${i} challenge_${i} 2> /dev/null
	${USERMOD} -d "" challenge_${i}
	${USERMOD} -s "/bin/false" challenge_${i} 
done

${ECHO} "[+] cleanup workdir ... "
${RM} ${WORKDIR} 

# Adding user ...
${ECHO} "[+] Adding group ..."
${GROUPADD} ${1}

${ECHO} "[+] Adding user ..."
RANDPASS=`${PASSWORD}`
${USERADD} ${1} -d /home/${1} -m -g ${1} -p $(${OPENSSL} passwd -1 ${RANDPASS})
${CHMOD} -R 0700 /home/${1}

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

# Build holygrail challenges
${ECHO} "[+] Building holygrail challenges ..."
for i in $(/bin/ls ./code/holygrail/*.c) ; do
  # Create challenge directory
  PROGRAM=`/bin/echo $i | /usr/bin/awk -F "/" '{print $4}' | /usr/bin/awk -F "." '{print $1}'`
  ${INSTALL} "${WORKDIR}/holygrail/${PROGRAM}"
  # Define challenge directory permissions
  ${CHOWN} ${1}.${1} "${WORKDIR}/holygrail"
  ${CHOWN} ${1}.${1} "${WORKDIR}/holygrail/${PROGRAM}"
  # Compile challenge and configure its permissions
  ${GCC} "${WORKDIR}/holygrail/$PROGRAM/${PROGRAM}" ${i}
  ${CP} ${i} "${WORKDIR}/holygrail/${PROGRAM}/"
  ${CHOWN} ${PROGRAM}.${PROGRAM} "${WORKDIR}/holygrail/${PROGRAM}/${PROGRAM}"
  ${CHMOD} 4555 "${WORKDIR}/holygrail/${PROGRAM}/${PROGRAM}"
  ${CHATTR} +i "${WORKDIR}/holygrail/${PROGRAM}/${PROGRAM}"
  # Create the challenge tag file
  ${TOUCH} "${WORKDIR}/holygrail/${PROGRAM}/${PROGRAM}.tag"
  ${CHOWN} ${PROGRAM}.${PROGRAM} "${WORKDIR}/holygrail/${PROGRAM}/${PROGRAM}.tag"
  ${CHMOD} 0600 "${WORKDIR}/holygrail/${PROGRAM}/${PROGRAM}.tag"
  ${CHATTR} +a "${WORKDIR}/holygrail/${PROGRAM}/${PROGRAM}.tag"
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

${ECHO} "Congratulations ${1}, you have been subscribed to the uCon Capture The Flag 2009 edition.\n\n" > ${MAILDIR}${MESSAGE}
${ECHO} "You should ssh the CTF machine in order to change the default password.\n" >> ${MAILDIR}${MESSAGE}
${ECHO} "Following up are user's credentials:\n\n" >> ${MAILDIR}${MESSAGE}
${ECHO} "IP address: ${IPADDR}\nLogin: ${1}\nPassword: ${RANDPASS}\n" >> ${MAILDIR}${MESSAGE}

if [ -e ./sendEmail-v1.55/sendEmail ]; then
  ${ECHO} "[+] Sending an email message with user credentials..."
  ${SENDMAIL} -t "${1} ${2}" -o message-file=${MAILDIR}${MESSAGE} -l ${MAILDIR}${LOGFILE}
else
  ${ECHO} "[+] Impossible to send user credentials through mail client..."
  ${CAT} ${MAILDIR}${MESSAGE}
fi
