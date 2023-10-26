#!/bin/bash
#    written by Jacob Obrman in June 2021
source ~/control/scripts/functions.sh
code=0
while [ $code -ne 1 ]
do
    code=$(/lib/chia-blockchain/resources/app.asar.unpacked/daemon/chia show -s | grep "Full Node Synced" | wc -l)
    echo $(date) code is $code
    [ $code -ne 0 ] && ( notifyTelegram "$(hostname): Full Node Synced" )
    sleep 30m
done
