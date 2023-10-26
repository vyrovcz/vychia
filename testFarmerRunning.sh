#!/bin/bash
source ~/control/scripts/functions.sh

test1=$(ps auxf | grep 'harvester' | wc -l)

#test2=$(cat .chia/mainnet/log/debug.log.1 .chia/mainnet/log/debug.log | tail -n 500 | grep -c -E "plots were eligible")

test3=$(cat .chia/mainnet/log/debug.log.1 .chia/mainnet/log/debug.log | tail -n 500 | grep -v "timed out" | grep -c -E "ERR")

tenminago=$(date -d "-10 min" "+%Y-%m-%dT%H:%M")
test2=$(grep -Pzo "$tenminago(.*\n)*" .chia/mainnet/log/debug.log.1 .chia/mainnet/log/debug.log | grep -c "plots were eligible")

test4=$(chia farm summary | grep -c arvester)

if [ $test1 -gt 1 ] && [ $test2 -gt 60 ] && [ $test3 -lt 4 ] && [ $test4 -gt 1 ]
then
    ok "$(date) harvester running"
else
    fail "harvester not running"
    notifyTelegram "$(hostname) WARNING! Harvester suspicious t1>1: $test1 t2>60: $test2 t3<4: $test3 t4>1: $test4"
fi
