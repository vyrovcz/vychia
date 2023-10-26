#!/bin/bash
source /home/vychia/control/scripts/functions.sh
plotters=( 1 2 3 4 5 8 )
command="ps auxf | grep 'chia plots create' | awk 'BEGIN {sum=0} {sum=sum+\$3} END {print sum}'"
echo
echo '***************************************'
echo "***** $(styleCyan "running cmd on all plotters") *****"
echo '***************************************'
echo "**   $(styleYellow "$command") **"
echo '***************************************'
echo
for plotter in "${plotters[@]}"
do
    echo
    echo '***************************************'
    echo "** running cmd on $(styleCyan "plotter00$plotter") ***"
    echo '***************************************'
    echo
    read -rsn1 -p"Press any key to start";echo
    ssh id@192.168.100.2$plotter "$command"
done
