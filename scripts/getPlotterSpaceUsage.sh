#!/bin/bash
#    written by Jacob Obrman in June 2021
source /home/vychia/control/scripts/functions.sh
plotters=( 1 2 3 4 5 8 )
command="df -h | egrep  'Mounted|plotting|Chia'"
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
