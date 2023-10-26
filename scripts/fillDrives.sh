#!/bin/bash
#    written by Jacob Obrman in June 2021
source /home/vychia/control/scripts/functions.sh
#plot source path
plotsource=/mnt/ChiaRAID02/PLOTS00/

ChiaDriveGroups=( 20 21 22 )

#minimum space required for 1 plot
minspace=108320096

for ChiaDriveGroup in "${ChiaDriveGroups[@]}"
do
    for ChiaDrive in {0..9}
    do
		path=/mnt/ChiaDrive"$ChiaDriveGroup""$ChiaDrive"
		driveFull=false
		#copy one plot per iteration
		while [ "$driveFull" = false ]
		do
			#find out the space on drive
			echo checking space on drive "$path"
			leftspace=$(df | grep "$path" | awk '{print $4}')
			#is enough space to move at least one k32 plot
			echo "  left space ~ $(("$leftspace"/1000000))GB"
			if [ "$minspace" -lt "$leftspace" ]
			then
				#get path of next plot to move
				nextplot=$(find "$plotsource" -type f -name "*" | head -n 1)
						#check if there are plots left to move on plotsource
				if [ $(echo "$nextplot" | grep k33 | wc -l) = 0 ]
				then
					notifyTelegram "$(hostname): fillDrivesA terminated, plotsource empty"
					exit
				fi
				ok "start moving plot $nextplot to $path/plots"
				rsync -avh --info=progress2 --no-i-r --remove-source-files "$nextplot" "$path"/plots
			else
				note "not enough space on "$path", picking next drive"
				#break while loop and continue with next drive
				driveFull=true
			fi
			echo sleeping 2 seconds
			sleep 2s
		done
    done
    note "no more drives to pick from, picking next drivegroup"
done
note "no more drivegroups to pick from, stop filling drives"
