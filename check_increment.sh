#!/bin/bash
#
# About: Script for File Acces
# Author: liberodark
# Thanks : lord, play-cool-friend
# License: GNU GPLv3

version="0.0.4"

echo "Welcome on Check Acces File $version"

#=================================================
# RETRIEVE ARGUMENTS FROM THE MANIFEST AND VAR
#=================================================

mail="my.email@domain.fr my.email@domain.com"
check_folder_1="/Data/365"
check_folder_2="/Data/90"
check_service=$(systemctl list-units --state=failed | grep rsyslog)
rsyslog_name="fr-ren-rsyslog"
duration="60"

# Check Folders
if [ ! -d "$check_folder_1" ]; then
echo "$check_folder_1 does not exists.." | mail -s "TEST KO" -r "$rsyslog_name" "$mail"
exit
fi

if [ ! -d "$check_folder_2" ]; then
echo "$check_folder_2 does not exists.." | mail -s "TEST KO" -r "$rsyslog_name" "$mail"
exit
fi

# Check Service
if [ -z "$check_service" ]; then
echo "Service is OK"
else
echo "$check_service service is failed.." | mail -s "TEST KO" -r "$rsyslog_name" "$mail"
exit
fi

usage ()
{
     echo "usage: check_increments.sh -switch"
     echo "options:"
     echo "-switch: for check switch"
     echo "-server: for check servers"
     echo "-firewall: for check bastion"
     echo "-h: Show help"
}

check_switch(){
#==============================================
# SWITCH
#==============================================
echo "Check Switchs"

switch_list="sw00
sw01"

for switch in $switch_list
    do
        if [ ! -e "${check_folder_2}/${switch}".log ]; then
            echo "${switch}.log does not exists.." | mail -s "TEST KO" -r "$rsyslog_name" "$mail"
    else
        command=$(find "${check_folder_2}/${switch}".log -mmin +${duration})
        if [ -z "$command" ]; then
            echo "Files would be OK" > /dev/null 2>&1
        
    else
            echo "$command is not incremented" | mail -s "TEST KO" -r "$rsyslog_name" "$mail"
    fi
fi
done
}

check_servers(){
#==============================================
# SERVERS CLASSE C
#==============================================
echo "Check Servers"

server_list="server00
server01"

for server in $server_list
    do
        if [ ! -e "${check_folder_2}/${server}".log ]; then
            echo "${server}.log does not exists.." | mail -s "TEST KO" -r "$rsyslog_name" "$mail"
    else
        command=$(find "${check_folder_2}/${server}".log -mmin +${duration})
        if [ -z "$command" ]; then
            echo "Files would be OK" > /dev/null 2>&1
        
    else
            echo "$command is not incremented" | mail -s "TEST KO" -r "$rsyslog_name" "$mail"
    fi
fi
done
}

check_firewall(){
#==============================================
# FIREWALL
#==============================================
echo "Check Firewall"

fw_list="fw00
fw01"

for fw in $fw_list
    do
        if [ ! -e "${check_folder_1}/${fw}".log ]; then
            echo "${fw}.log does not exists.." | mail -s "TEST KO" -r "$rsyslog_name" "$mail"
    else
        command=$(find "${check_folder_1}/${fw}".log -mmin +${duration})
        if [ -z "$command" ]; then
            echo "Files would be OK" > /dev/null 2>&1
        
    else
            echo "$command is not incremented" | mail -s "TEST KO" -r "$rsyslog_name" "$mail"
    fi
fi
done
}

parse_args ()
{
    while [ $# -ne 0 ]
    do
        case "${1}" in
            -switch)
                shift
                check_switch >&2
                return 0
                ;;
            -server)
                shift
                check_servers >&2
                return 0
                ;;
            -firewall)
                shift
                check_firewall >&2
                return 0
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                echo "Invalid argument : ${1}" >&2
                usage >&2
                exit 1
                ;;
        esac
        shift
    done

}

parse_args "$@"
