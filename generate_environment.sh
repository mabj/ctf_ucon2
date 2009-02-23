#!/bin/sh

rm -rf ctf_ucon2

install -d ./ctf_ucon2/admin
cp -af create_user.sh ./ctf_ucon2/admin
cp -af remove_user.sh ./ctf_ucon2/admin
cp -af sendEmail-v1.55/ ./ctf_ucon2/admin
cp -af setup.sh ./ctf_ucon2/admin

install -d ./ctf_ucon2/admin/code
install -d ./ctf_ucon2/admin/code/crackme
install -d ./ctf_ucon2/admin/code/vulndev

cp -af ../crack/challenge_01.c ./ctf_ucon2/admin/code/crackme/challenge_01.c
cp -af ../crack/challenge_02.c ./ctf_ucon2/admin/code/crackme/challenge_02.c
cp -af ../crack/challenge_03.c ./ctf_ucon2/admin/code/crackme/challenge_03.c
cp -af ../crack/challenge_05.c ./ctf_ucon2/admin/code/crackme/challenge_04.c
cp -af ../crack/challenge_04.c ./ctf_ucon2/admin/code/crackme/challenge_05.c

cp -af ../stack/challenge_01.c ./ctf_ucon2/admin/code/vulndev/challenge_06.c
cp -af ../format/challenge_01.c ./ctf_ucon2/admin/code/vulndev/challenge_07.c
cp -af ../stack/challenge_04.c ./ctf_ucon2/admin/code/vulndev/challenge_08.c
cp -af ../format/challenge_03.c ./ctf_ucon2/admin/code/vulndev/challenge_09.c
cp -af ../stack/challenge_06.c ./ctf_ucon2/admin/code/vulndev/challenge_10.c
cp -af ../stack/challenge_05.c ./ctf_ucon2/admin/code/vulndev/challenge_11.c

install -d ./ctf_ucon2/interface/telnetd
install -d ./ctf_ucon2/interface/web
cp -af interface/telnetd/* ./ctf_ucon2/interface/telnetd/
cp -af interface/web/ucon2/* ./ctf_ucon2/interface/web/

install -d ./ctf_ucon2/bot
cp -af ./../bot/counter_bot* ./ctf_ucon2/bot/
