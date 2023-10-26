#!/bin/bash
#    written by Jacob Obrman in June 2021
source ~/control/scripts/functions.sh

source=/mnt/plotting*/plots/plot*plot
farmingDisks=( 793 792 791 790 )
for fDisk in "${farmingDisks[@]}"
do
    returncode=0
    #move plots until rsync complains (usually when full)
    while [ $returncode -eq 0 ] || [ $returncode -eq 23 ]
    do
	#move plots from plotters to ChiaDrive (ssd to Network-HDD)
	rsync -avh --info=progress2 --no-i-r --remove-source-files $source id@10.0.30.11:/mnt/ChiaDrive"$fDisk"/plots
	returncode=$?
	#check again in 10 minutes for new plots
	echo "sleeping until $(date) + 10min (returncode = $returncode)"
	sleep 600
    done
    notifyTelegram "$(hostname): plotcollectorNET filled ChiaDrive$fDisk"
done
notifyTelegram "$(hostname): plotcollectorNET terminated"
