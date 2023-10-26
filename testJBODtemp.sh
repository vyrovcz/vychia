#!/bin/bash
source ~/control/scripts/functions.sh

# test controller info
info=$(./control/utilities/cli-RAID/cli64 "hw info")
# test CPU temp
cputemp=$(echo "$info" | grep "CPU Temp" | awk '{print $4}')
if [ $cputemp -lt 78 ];then
    ok "$(date) CPU temp is fine"
else
    fail "$(date) CPU temp too high"
    notifyTelegram "$(hostname): WARNING! JBOD CTRL CPU Temp too high: $cputemp"
fi

# test enclosure temp
for i in $(seq 3); do
    enctempA=$(echo "$info" | grep "TempSense0$i" | head -n 1 | awk '{print $3}')
    enctempB=$(echo "$info" | grep "TempSense0$i" | tail -n 1 | awk '{print $3}')
    if [ $enctempA -lt 50 ] && [ $enctempB -lt 50 ];then
	ok "$(date) CPU temp is fine: $enctempA & $enctempB"
    else
	fail "$(date) enc temp too high"
	notifyTelegram "$(hostname): WARNING! JBOD Encl Temp too high: $enctempA & enctempB"
    fi
done

# test temp of two random disks
random1=$((RANDOM%120+9))
random2=$((RANDOM%120+9))
info1=$(./control/utilities/cli-RAID/cli64 "disk info drv=$random1")
info2=$(./control/utilities/cli-RAID/cli64 "disk info drv=$random2")

# log disk info just in case
echo "disk=$random1" >> JBODdiskinfos
echo "$info1" >> JBODdiskinfos
echo "disk=$random2" >> JBODdiskinfos
echo "$info2" >> JBODdiskinfos

disktemp1=$(echo "$info1" | grep "Temp" | awk '{print $4}')
disktemp2=$(echo "$info2" | grep "Temp" | awk '{print $4}')

if [ $disktemp1 -lt 43 ] && [ $disktemp2 -lt 43 ];then
    ok "$(date) disk temp is fine: $disktemp1 & $disktemp2"
else
    fail "$(date) disk temp too high: $disktemp1 & $disktemp2"
    notifyTelegram "$(hostname): WARNING! JBOD disk too high:disk=$random1: $disktemp1 & disk=$random2: $disktemp2"
fi
