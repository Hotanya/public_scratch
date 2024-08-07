#!/bin/bash

TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[0;33m'
TEXT_RED_B='\e[1;31m'
TEXT_GREEN='\e[32m'

if [ "$EUID" -ne 0 ]
  then echo -en $TEXT_RED_B; echo "[!] Must be run as root"; echo -en $TEXT_RESET
  exit
fi

/usr/games/fortune -a | /usr/games/cowsay 


echo -en $TEXT_GREEN
echo '[!] Starting apt update ...'
echo -en $TEXT_RESET

DEBIAN_FRONTEND=noninteractive apt-get -yq update > /dev/null
echo -en $TEXT_YELLOW
echo '   [*] APT update finished'
echo -en $TEXT_RESET

#sudo apt-get dist-upgrade
#echo -en $TEXT_YELLOW
#echo 'APT distributive upgrade finished...'
#echo -en $TEXT_RESET

DEBIAN_FRONTEND=noninteractive apt-get -yq upgrade > /dev/null
echo -en $TEXT_YELLOW
echo '   [*] APT upgrade finished...'
echo -en $TEXT_RESET

DEBIAN_FRONTEND=noninteractive apt-get -yq autoremove > /dev/null
echo -en $TEXT_YELLOW
echo '   [*] APT auto remove finished'
echo -en $TEXT_RESET

DEBIAN_FRONTEND=noninteractive apt-get -yq clean > /dev/null
DEBIAN_FRONTEND=noninteractive apt-get -yq autoclean > /dev/null
echo -en $TEXT_GREEN
echo '   [*] Cleanup finished'
echo -en $TEXT_RESET

if [ -f /var/run/reboot-required ]; then
    echo -en $TEXT_RED_B
    echo '[!] Reboot required'
    echo -en $TEXT_RESET
fi
