#!/bin/bash
source ~/control/scripts/functions.sh

#minimum space (GiB) required for 1 k34 plot
minspace=431
#plot source
source=/mnt/plotting*/plots/plot-k34*plot
#plot destination
server=id@10.0.20.11
farmingDisks=(
)

for fDisk in "${farmingDisks[@]}"
do

    path=/mnt/ChiaDrive$fDisk
    k34count=$(ssh $server "ls -l $path/plots/ | grep plot-k34 | wc -l")
    #loop over disk until 1 k34-plots are stored or no more k32-plots left to remove
    while [ $k34count -lt 1 ]
    do
	echo k34-plotcount on $path is $k34count

	#get the next k34 plot ready
	nextplot=$(find $source -type f -name "*" | grep plot-k34 | head -n 1)
	#test if there are any k34-plots, if not, wait 10 minutes
	while [ $(echo $nextplot | grep plot-k34 | wc -l) = 0 ]
	do
	    echo no k34-plots available, waiting til $(date) + 30min
	    sleep 1800
	    nextplot=$(find $source -type f -name "*" | grep plot-k34 | head -n 1)
	done

	echo next k34-plot is prepared for replacement

	#get the free space of the disk
	leftspace=$(ssh $server "df -BG | grep $path" | awk '{print $4}')
	#cut away the "G" char at the end of the df output
	leftspace=${leftspace%?}
	echo leftspace on $path is $leftspace now
	#make room: remove k32-plots until a k34-plot fits
	while [ $leftspace -lt $minspace ]
	do
	    #remove the next k32-plot
	    oldplot=$(ssh $server "find $path/plots/ -type f -name '*' | grep 'plot-k32' | head -n 1")
	    ssh $server "rm $oldplot"

	    #check for rm errors, if error, pick next disk
	    [ $? -ne 0 ] && ( notifyTelegram "$(hostname): plotreplacerNET rm failed on $path, skipping"; break 2 )

	    leftspace=$(ssh $server "df -BG | grep $path" | awk '{print $4}')
	    echo removed k32-plot, leftspace on $path is $leftspace now
	    leftspace=${leftspace%?}
	    sleep 2s
	done

	#copy the next k34-plot
	ok "    start moving plot $nextplot to $path/plots"
	rsync -avh --info=progress2 --no-i-r --remove-source-files $nextplot $server:$path/plots

	#check for rsync errors
	[ $? -ne 0 ] && ( notifyTelegram "$(hostname): plotreplacerNET rsync failed on $path, skipping"; break )

	k34count=$(ssh $server "ls -l $path/plots/ | grep plot-k34 | wc -l")
	sleep 1s
    done
    ok "  done with $path, choosing next ChiaDrive"
    sleep 1s
done
ok "done replacing"
notifyTelegram "$(hostname): plotreplacerNET terminated"
