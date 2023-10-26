#!/bin/bash
source ~/control/scripts/functions.sh
command=". ./chia-blockchain/activate && chia farm summary"
echo
echo '***************************************'
echo "***** $(styleCyan "running cmd on all harvesters") *****"
echo '***************************************'
echo "***   $(styleYellow "$command") *****"
echo '***************************************'
echo
echo '***************************************'
echo "***   $(styleOrange "DCA harvesters") *****"
echo '***************************************'

harvesters=( 7 8 9 10 )
#this machine
echo
echo '***************************************'
echo "** DCA server 6 ***"
echo '***************************************'
echo

eval "$command"
for harvester in "${harvesters[@]}"
do
    echo
    echo '***************************************'
    echo "** DCA server $(($harvester-6)) ***"
    echo '***************************************'
    echo
    #read -rsn1 -p"Press any key to start";echo
    ssh id@10.0.20.$harvester "$command"
done

echo '***************************************'
echo "***   $(styleOrange "DCB harvesters") *****"
echo '***************************************'
harvesters=( 2 3 4 5 )
for harvester in "${harvesters[@]}"
do
    echo
    echo '***************************************'
    echo "** DCB server $((harvester-1)) ***"
    echo '***************************************'
    echo
    #read -rsn1 -p"Press any key to start";echo
    ssh id@10.0.20.$harvester "$command"
done
