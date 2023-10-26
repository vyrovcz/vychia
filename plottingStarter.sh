#!/bin/bash
echo starting harvester
. ./chia-blockchain/activate
chia start harvester

#plotter specific settings
k=32
n=1
bram=3400
rthreads=2
ubuckets=128
farmerpk=8862ebfbda517c78444c615733b121f53d1dddb5323eeaca38fbc01f610f9f2c3c765cc56c1f550cab61c5b330a913b5
poolpk=97e4f9ae00920726f7a60ffac88e0c5177979779f1096d3c61dad66bf823469744e31338efecca5507ab230ab1ec3c06

#the letters represent the concurrent plotting processes on one plotting Disk
plottingLetters=( a b c d )
#these are the plotting disks available to the system
plottingDisks=( 00 01 02 03 04 05 06 07 )
#start plot collector to clean ssds from finished plots
echo starting plotcollector
bash control/scripts/plotcollectorNET.sh &> control/logs/plotcollectorNET.log &
#dispatch plotting processes
for pLetter in "${plottingLetters[@]}"
do
    currentDisk=0
    #first start a plotting process on each plotting disk, after all plotting disks are creating a plot, start plotting more
    for pDisk in "${plottingDisks[@]}"
    do
	t=/mnt/plotting$pDisk/plotting/$pLetter
	k=$k
	n=$n
	b=$bram
	r=$rthreads
	u=$ubuckets
	d=/mnt/plotting$pDisk/plots
	f=$farmerpk
	p=$poolpk
	echo starting plot on $t to $d
	control/scripts/plotdispatcher.sh $t $k $n $b $r $u $d $f $p &> control/logs/plotting$pDisk$pLetter &
	#wait some time
	echo sleeping until $(date) + 20m
	sleep 20m
    done
    #wait some time
    echo sleeping until $(date) + 10m
    sleep 10m
done
sleep 60d
