#!/bin/bash
source ~/control/scripts/functions.sh

#minimum space required for 1 plot
minspace=108320096
#plotsource
source=/mnt/plotting*/plots/plot*plot

# Scan for available ChiaDrives
df -h | grep ChiaDrive | awk '{print $6}' > control/plotcollectorDrives

# For each available ChiaDrive
for drive in $(cat control/plotcollectorDrives)
do
    returncode=0
    #find out the space on drive
    echo checking space on $drive
    leftspace=$(df | grep $drive | awk '{print $4}')
    #is enough space to move at least one k32 plot
    echo "  left space ~ $(($leftspace/1000000))GB"
    if [ $minspace -lt $leftspace ]
    then
	ok " start collecting plots to $drive"
	returncode=0
    else
	note " not enough space, picking next drive"
	returncode=1
    fi
    #run as long as rsync is happy (return code == 0 or 23)
    while [ $returncode -eq 0 ] || [ $returncode -eq 23 ]
    do
	#move plots from plotters to ChiaDrive (ssd to HDD)
	rsync -avh --info=progress2 --no-i-r --remove-source-files $source $drive/plots
	returncode=$?
	#check again in 10 minutes for new plots
	echo "sleeping until $(date) + 10min (returncode = $returncode)"
	sleep 600
    done
done
