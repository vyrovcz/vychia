#!/bin/bash
#    written by Jacob Obrman in June 2021
while true
do
    # get power situation
    x1=$(sudo apcaccess | grep "STATUS   : ONLINE" | wc -l)  #ONBATT
    # while power outage detected
    while [ $x1 -eq 0 ]; do
	# get current battery info
	battper=$(sudo apcaccess | grep BCHARGE | awk '{print $3}')
	batttimeleft=$(sudo apcaccess | grep TIMELEFT | awk '{print $3}')
	# send notification
	curl -s -X POST https://api.telegram.org/botxxx:xxx/sendMessage -d chat_id=xxx -d text="Warning! Power Outage detected vyChia-Farm%0ABattery Charge : $battper%%0ATime left : $batttimeleft Min"
	sleep 60s
	x1=$(sudo apcaccess | grep "STATUS   : ONLINE" | wc -l)
	if [ $(sudo apcaccess | grep "STATUS   : ONLINE" | wc -l) -eq 1 ]; then
	    # send notification
	    curl -s -X POST https://api.telegram.org/botxxx:xxx/sendMessage -d chat_id=xxx -d text="Power in DataCenterB is back online"
	fi
    done
    sleep 120s
done
