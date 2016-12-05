#!/bin/bash

if [[ $# -ne 2 ]]; then 
    echo "Wrong usage: attended <host_name> <time_in_minute>"
    echo "exemple : ./script.sh serveur 5"
    exit
else
    while true; do
	time=$(date +%s)
	
	var=$(./check_centreon_snmp_cpu -H 127.0.0.1 -C SNMP-S@G3S2 -v 2c -w 80 -c 90)
	echo "[$time]"" PROCESS_SERVICE_CHECK_RESULT;$1;cpu;0;""$var" > $1
	
	var2=$(exec ./check_centreon_snmp_memory  -H 127.0.0.1 -C SNMP-S@G3S2 -v 2c)
	echo "[$time]"" PROCESS_SERVICE_CHECK_RESULT;$1;memory;0;""$var2" >> $1
	
	var3=$(exec ./check_centreon_snmp_uptime -H 127.0.0.1 -C SNMP-S@G3S2 -v 2c)
	echo "[$time]"" PROCESS_SERVICE_CHECK_RESULT;$1;uptime;" "$var3" >> $1

	var4=$(./check_dhcp)
	echo "[$time]"" PROCESS_SERVICE_CHECK_RESULT;$1;dhcp;OK;""$var4" >> $1
	
	var5=$(./check_disk /)
	echo "[$time]"" PROCESS_SERVICE_CHECK_RESULT;$1;disk;OK;""$var5" >> $1
	
	var6=$(ps -ef | grep postgres | grep -v grep | awk '{print $3}'| tail -n 1)
	if [ ! $var6 ]; then
	    echo "[$time]"" PROCESS_SERVICE_CHECK_RESULT;$1;process;2;NO PROCESS FOUND" >> $1
	else
	    echo "[$time]"" PROCESS_SERVICE_CHECK_RESULT;$1;process;OK;""PPID = $var6 OK PROCESS RUNING NORMALLY" >> $1
	fi
	var7=$(curl -X POST --http1.0  -i  -x proxy.cpam-bordeaux.cnamts.fr:3128 -U STAGIAIRE-74006:netscape -L -H "Content-Type:multipart/form-data" -F fichier=@$1 http://185.135.127.72/centreon/monitoring.php)
	echo "$var7" > LOG
	
	echo -n "" > nohup.out

	sleep $2m
	
    done
fi