#!/bin/bash

latest=$(curl -sL https://api.github.com/repos/OCSInventory-NG/OCSInventory-ocsreports/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
curent=$(grep GUI_VER_SHOW /usr/share/ocsinventory-reports/ocsreports/var.php |  awk -F"'" '{print $4}')

if [ "$latest" = "$curent" ]; then
    echo 0 > /srv/script/version_OCS_server.txt
else
    echo "$latest" > /srv/script/version_OCS_server.txt
fi


#Add in zabbix agent for check ocs version up-to-date: UserParameter=version.ocs,cat /srv/script/version_OCS_server.txt
