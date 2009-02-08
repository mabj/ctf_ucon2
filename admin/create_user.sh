#!/bin/bash

GCC="/usr/bin/gcc -fno-stack-protector -ggdb -o "
MAKE="/usr/bin/make"
INSTALL="/usr/bin/install -d"
FIND="/usr/bin/find"
RM="/bin/rm -rf"
WORKDIR="./ucon2"
CP="/bin/cp -af"
CHOWN="/bin/chown"
CHMOD="/bin/chmod"
OPENSSL="/usr/bin/openssl"
PASSWORD="$OPENSSL rand -base64 8"
USERADD="/usr/sbin/useradd"
GROUPADD="/usr/sbin/groupadd"
USERMOD="/usr/sbin/usermod"

# Verify parameters
if [ $# != 2 ]; then
	echo -e ".:: uCon 2 Capture The Flag ::.\n"
	echo -e "   Usage: $0 [user_name] [user_mail]\n"
	exit 1
fi

if [ -e "/home/$1" ]; then
	echo -e "\n[!] O usuario [$1] ja foi adicionado\n"
	exit 1
fi

# Add challenge users
for i in 01 02 03 04 05 06 07 08 09 10 11; do
	$USERADD -u 10$i challenge_$i 2> /dev/null
	$USERMOD -d "" challenge_$i
	$USERMOD -s "/bin/false" challenge_$i 
done


echo -e "[+] cleanup workdir ... "
${RM} ${WORKDIR} 

# Adding user ...
echo -e "[+] Adding group ..."
  $GROUPADD $1
echo -e "[+] Adding user ..."
  $USERADD $1 -d /home/$1 -m -g $1 -p $($OPENSSL passwd -1 `$PASSWORD`)
  $CHMOD -R 0700 /home/$1

echo -e "[+] Garantindo previlegios ao diretorio de trabalho"
${INSTALL} ${WORKDIR}
$CHOWN $1.$1 $WORKDIR

# Build challenges
echo -e "[+] Building crackme challenges ..."
for i in $(/bin/ls ./code/crackme/*.c) ; do
  PROGRAM=`echo $i | awk -F "/" '{print $4}' | awk -F "." '{print $1}'`
  $INSTALL "${WORKDIR}/crackme/${PROGRAM}"
	$CHOWN $1.$1 "${WORKDIR}/crackme"
  $CHOWN -R $1.$1 "${WORKDIR}/crackme/${PROGRAM}"
  $GCC "${WORKDIR}/crackme/${PROGRAM}/${PROGRAM}" $i
  $CHOWN ${PROGRAM}.${PROGRAM} "${WORKDIR}/crackme/${PROGRAM}/${PROGRAM}"
  $CHMOD 4555 "${WORKDIR}/crackme/${PROGRAM}/${PROGRAM}"
done

echo -e "[+] Building vulndev challenges ..."
for i in $(/bin/ls ./code/vulndev/*.c) ; do
  PROGRAM=`echo $i | awk -F "/" '{print $4}' | awk -F "." '{print $1}'`
  $INSTALL "${WORKDIR}/vulndev/${PROGRAM}"
  $CHOWN $1.$1 "${WORKDIR}/vulndev"
  $CHOWN -R $1.$1 "${WORKDIR}/vulndev/${PROGRAM}"
  $GCC "${WORKDIR}/vulndev/${PROGRAM}/${PROGRAM}" $i
  $CP $i "${WORKDIR}/vulndev/$PROGRAM/"
  $CHOWN ${PROGRAM}.${PROGRAM} "${WORKDIR}/vulndev/${PROGRAM}/${PROGRAM}"
  $CHMOD 4555 "${WORKDIR}/vulndev/${PROGRAM}/${PROGRAM}"
done

echo -e "[+] Building holygrail challenges ..."
for i in $(/bin/ls ./code/holygrail/*.c) ; do
  PROGRAM=`echo $i | awk -F "/" '{print $4}' | awk -F "." '{print $1}'`
  $INSTALL "${WORKDIR}/holygrail/${PROGRAM}"
  $CHOWN $1.$1 "${WORKDIR}/holygrail"
  $CHOWN $1.$1 "${WORKDIR}/holygrail/${PROGRAM}"
  $GCC "${WORKDIR}/holygrail/$PROGRAM/${PROGRAM}" $i
  $CP $i "${WORKDIR}/holygrail/${PROGRAM}/"
  $CHOWN ${PROGRAM}.${PROGRAM} "${WORKDIR}/holygrail/${PROGRAM}/${PROGRAM}"
  $CHMOD 4555 "${WORKDIR}/holygrail/${PROGRAM}/${PROGRAM}"
  # TODO: sacar o esquema de apenas o root poder apagar o arquivo
done

# Copying workdir to the user home  
echo -e "[+] Copiando o diretorio de trabalho para o home"
  $CP ${WORKDIR} "/home/$1"
  $RM ${WORKDIR}

# Changing directories permissions
  $FIND "/home/$1" -iname *.c -exec $CHOWN $1.$1 {} \;

# Sending mail ...
echo -e "[+] Enviando email com credenciais ... "
