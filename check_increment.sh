#!/bin/bash
#
# About: Script for File Acces
# Author: liberodark
# Thanks : lord, play-cool-friend
# License: GNU GPLv3

version="0.0.1"

echo "Welcome on Check Acces File $version"

#=================================================
# CHECK ROOT
#=================================================

if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

#=================================================
# RETRIEVE ARGUMENTS FROM THE MANIFEST AND VAR
#=================================================

distribution=$(cat /etc/*release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/["]//g' | awk '{print $1}')
mail="my.email@domain.fr"
check_folder_1=$(find /Data/365/* -mmin +120)
check_folder_2=$(find /Data/90/* -mmin +120)


if [ -z "$check_folder_1" ]; then
echo "Files would be OK"
else
echo "Error files not be modified in 2h"
echo "$check_folder_1" | mail -s "TEST KO" -r "my_domain" "$mail"
fi

if [ -z "$check_folder_2" ]; then
echo "Files would be OK"
else
echo "Error files not be modified in 2h"
echo "$check_folder_2" | mail -s "TEST KO" -r "my_domain" "$mail"
fi
