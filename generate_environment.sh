#!/bin/bash
#
# generate_environment.sh is a piece of uCon 2009 Capture The Flag code
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

INSTALL="/usr/bin/install -d"
FIND="/usr/bin/find"
RM="/bin/rm -rf"
WORKDIR="./ctf_ucon2_build"
CP="/bin/cp -af"
ECHO="/bin/echo -e"
TAR="/bin/tar cfj"

cleanup_environment() {
  ${ECHO} '[+] Cleanup the environment for a new build ...'
  ${FIND} ./ -iname *~ -exec ${RM} {} \;
  ${RM} ${WORKDIR}
}

build_admin_directory() {
  ${INSTALL} ${WORKDIR}/admin
  ${CP} ./admin/create_user.sh ${WORKDIR}/admin
  ${CP} ./admin/remove_user.sh ${WORKDIR}/admin
  ${CP} ./admin/sendEmail-v1.55/ ${WORKDIR}/admin
  ${CP} ./admin/setup_environment.sh ${WORKDIR}/admin
  ${CP} ./admin/firewall-rules ${WORKDIR}/admin
}

copy_crackme_sources() {
  ${ECHO} "[+] coping crackme challenges sources"
  ${CP} ./challenges/crack/challenge_01.c ${WORKDIR}/admin/code/crackme/challenge_01.c
  ${CP} ./challenges/crack/challenge_02.c ${WORKDIR}/admin/code/crackme/challenge_02.c
  ${CP} ./challenges/crack/challenge_03.c ${WORKDIR}/admin/code/crackme/challenge_03.c
  ${CP} ./challenges/crack/challenge_05.c ${WORKDIR}/admin/code/crackme/challenge_04.c
  ${CP} ./challenges/crack/challenge_04.c ${WORKDIR}/admin/code/crackme/challenge_05.c
}

copy_vulndev_sources() {
  ${ECHO} "[+] Coping vulndev challenges sources"
  ${CP} ./challenges/stack/challenge_01.c ${WORKDIR}/admin/code/vulndev/challenge_06.c
  ${CP} ./challenges/format/challenge_01.c ${WORKDIR}/admin/code/vulndev/challenge_07.c
  ${CP} ./challenges/stack/challenge_04.c ${WORKDIR}/admin/code/vulndev/challenge_08.c
  ${CP} ./challenges/format/challenge_03.c ${WORKDIR}/admin/code/vulndev/challenge_09.c
  ${CP} ./challenges/stack/challenge_06.c ${WORKDIR}/admin/code/vulndev/challenge_10.c
  ${CP} ./challenges/stack/challenge_05.c ${WORKDIR}/admin/code/vulndev/challenge_11.c
}

copy_challenges_sources() {
  ${ECHO} "[+] Creating challenges directories"
  ${INSTALL} ${WORKDIR}/admin/code
  ${INSTALL} ${WORKDIR}/admin/code/crackme
  ${INSTALL} ${WORKDIR}/admin/code/vulndev
  copy_crackme_sources
  copy_vulndev_sources
}

build_interface_directory() {
  ${ECHO} "[+] Build interface directory"
  ${INSTALL} ${WORKDIR}/interface/telnetd
  ${INSTALL} ${WORKDIR}/interface/web
  ${CP} interface/telnetd/* ${WORKDIR}/interface/telnetd/
  ${CP} interface/web/* ${WORKDIR}/interface/web/
}

build_bot_directory() {
  ${ECHO} "[+] Build bot directory"
  ${INSTALL} ${WORKDIR}/bot
  ${CP} ./bot/counter_bot* ${WORKDIR}/bot/
}

compress_build_directory() {
  ${ECHO} "[+] Compressing build directory"
  ${TAR} ${WORKDIR}.tar.bz2 ${WORKDIR}
}

cleanup_tmp_build_directory() {
  ${ECHO} "[+] Cleanup temp build directory"
  ${RM} ctf_ucon2_build
}

print_finish_message() {
  ${ECHO}
  ${ECHO} ".:: The Capture the Flag enviroment was created with success"
  ${ECHO} ".:: Copy the ${WORKDIR}.tar.bz2 to the virtual machine"
  ${ECHO}
}

cleanup_environment
build_admin_directory
copy_challenges_sources
build_interface_directory
build_bot_directory
compress_build_directory
cleanup_tmp_build_directory
print_finish_message

${ECHO} "DONE ! \O/"
