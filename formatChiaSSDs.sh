#!/bin/bash
drivelist="$1"
echo considering to format the following drives:
echo
for drive in $(cat "$drivelist")
do
    echo "$drive"
done
echo
read -rsn1 -p"Press any key to continue";echo
echo
echo attached block devices:
echo
lsblk -o name,size,label,mountpoint,fstype
echo
read -rsn1 -p"Warning, formatting the drives next, STRG + C to abort";echo
read -rsn1 -p"Last warning, drive contents will be lost, STRG + C to abort";echo
echo starting drive formatting now
echo
#labelcount
count=0
. ./chia-blockchain/activate
for drive in $(cat "$drivelist")
do
    echo "formatting drive $drive with label plotting0$count"
    sudo parted /dev/"$drive" mklabel gpt
    sleep 1s
    sudo parted /dev/"$drive" mkpart primary ext4 0% 100%
    sleep 2s
    sudo mkfs.ext4 -L plotting0"$count" /dev/${drive}p1
    sleep 2s
    sudo mkdir /mnt/plotting0"$count"
    echo "mounting drive $drive with label plotting0$count to /mnt/plotting0$count"
    sudo mount -L plotting0"$count" /mnt/plotting0"$count"
    sleep 1s
    sudo chown -R id:id /mnt/plotting0"$count"
    mkdir /mnt/plotting0"$count"/plots
    mkdir /mnt/plotting0"$count"/plotting/a -p
    mkdir /mnt/plotting0"$count"/plotting/b
    mkdir /mnt/plotting0"$count"/plotting/c
    mkdir /mnt/plotting0"$count"/plotting/d
    mkdir /mnt/plotting0"$count"/plotting/e
    chia plots add -d /mnt/plotting0"$count"/plots
    count=$((count + 1))
    echo sleeping 3s
    sleep 3s
done
echo
read -rsn1 -p"Press any key to continue";echo
echo
echo attached block devices:
echo
lsblk -o name,size,label,mountpoint,fstype
