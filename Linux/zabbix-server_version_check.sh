#!/bin/bash

#The script checks if there is a new version for zabbix server in the repository if yes save version number to /srv/script/version_zabbix_server.txt
#We can use it for automatic check zabbix is up to date or other software.  
#Add in zabbix agent for check Zabbix-server version up-to-date: UserParameter=version.ocs,cat /srv/script/version_zabbix_server.txt

package="zabbix-server-mysql.x86_64""

versions=$(yum list --upgrades 2>/dev/null | grep "$package" | awk '/^'"$package"'/ {print $2}')

if [[ -z $versions ]]; then
    echo 0 > /srv/script/version_zabbix_server.txt
else
    echo "$versions" > /srv/script/version_zabbix_server.txt
fi
