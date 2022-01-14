#!/bin/sh

check=$(curl -o /dev/null -sIw '%{http_code}' localhost/health)

while [ $check == 200 ]
do
curl -s localhost/health | grep -i "health" | sed 's/["]/ /g'| sed 's/[,:}]//g' | grep -o 'requestLatency.*' | awk '{print $2" "$4" "$6}' >> /tmp/log.txt
        count=`cat /tmp/log.txt |wc -l`
        if [ $count == 6 ]
        then

				cat /tmp/log.txt | awk '{if(min==""){min=max=$1}; if($1>max) {max=$1}; if($1<min) {min=$1}; total+=$1; count+=1} END {print "requestLatency Average: "total/count,"Max: "max,"Min: "min}' 
                cat /tmp/log.txt | awk '{if(min==""){min=max=$2}; if($2>max) {max=$2}; if($2<min) {min=$2}; total+=$2; count+=2} END {print "dbLatency Average: "total/count,"Max: "max,"Min: "min}' 
                cat /tmp/log.txt | awk '{if(min==""){min=max=$3}; if($3>max) {max=$3}; if($3<min) {min=$3}; total+=$3; count+=3} END {print "cacheLatency Average: "total/count,"Max: "max,"Min: "min}' 
				cat /dev/null > /tmp/log.txt
		fi
		
	sleep 10

done | exit 1