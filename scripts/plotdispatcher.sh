#!/bin/bash
#    written by Jacob Obrman in June 2021
t=$1
k=$2
n=$3
b=$4
r=$5
u=$6
d=$7
f=$8
p=$9
counter=0
while :
do
    chia plots create -t $t -k $k -n $n -b $b -r $r -u $u -d $t -f $f -p $p
    sleep 1s
    echo
    echo moving finished plot...
    echo
    #manually moving created plot to save SSD write cycles
    mv $t/plot*plot $d/
    echo "done"
    counter=$((counter + 1))
    echo
    echo "finished plots = $counter"
    echo
done
