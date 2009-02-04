#!/bin/bash

USERDEL="/usr/sbin/userdel"
RM="rm -rf "

if [ $# != 1 ]; then
	echo -e ".:: uCon 2 Capture The Flag ::.\n"
	echo -e "   Usage: $0 [user_name]\n"
	exit 1
fi

echo -e "[+] Apacando home do usuario"
$RM "/home/$1"
echo -e "[+] Apagando usuario do sistema ..."
$USERDEL $1



