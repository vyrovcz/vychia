#!/bin/bash
#    written by Jacob Obrman in June 2021
#the drive device paths given with first argument
drivelist="$1"
#the first two numbers of the ChiaDrive
drivegroup=90
#where to start counting from for the last number of the ChiaDrive
count=8
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
. ./chia-blockchain/activate
for drive in $(cat "$drivelist")
do
    echo "formatting drive $drive with label ChiaDrive$drivegroup$count"
    sudo parted /dev/"$drive" mklabel gpt
    sleep 1s
    sudo parted /dev/"$drive" mkpart primary ext4 0% 100%
    sleep 2s
    sudo mkfs.ext4 -L ChiaDrive"$drivegroup"$count -T largefile4 -m 0 /dev/${drive}1
    sleep 2s
    sudo mkdir /mnt/ChiaDrive"$drivegroup""$count"
    sudo mount -L ChiaDrive"$drivegroup""$count" /mnt/ChiaDrive"$drivegroup""$count"
    sleep 1s
    sudo chown -R id:id /mnt/ChiaDrive"$drivegroup""$count"
    mkdir /mnt/ChiaDrive"$drivegroup""$count"/plots
    chia plots add -d /mnt/ChiaDrive"$drivegroup""$count"/plots
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
