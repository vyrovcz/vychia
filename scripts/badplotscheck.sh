#!/bin/bash
#    written by Jacob Obrman in June 2021
badplotids "$1"
. ./chia-blockchain/activate
echo starting now
for plot in $(cat "$badplotids")
do
    chia plots check -n 15 -g "$plot"
done

    
