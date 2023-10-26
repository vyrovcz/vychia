#!/bin/bash
#    written by Jacob Obrman in June 2021
source /home/vychia/control/scripts/functions.sh

echo get all unmounted labels...
lsblk -o name,fstype,size,label,mountpoint | egrep -v 'mnt' | egrep 'Chia|plotting' | awk '{print $4}' | sort > unmountedLabels
echo found unmounted drives:
echo
cat unmountedLabels
echo
echo mounting drives now
read -rsn1 -p"Press any key to start";echo
for drive in $(cat unmountedLabels)
do
    echo mounting "$drive" to /mnt/"$drive"
    echo checking if mountpoint exists
    ls /mnt/"$drive" &> /dev/null
    if [ $? -eq 2 ]
    then
	note "  mountpoint does not exist, creating now"
	mkdir /mnt/"$drive"
	sudo chown vychia:vychia /mnt/"$drive"
    else
	ok "  mountpoint exists"
    fi
    sudo mount -L "$drive" /mnt/"$drive"
done
rm unmountedLabels
