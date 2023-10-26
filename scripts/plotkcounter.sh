#!/bin/bash
#    written by Jacob Obrman in June 2021
source ~/control/scripts/functions.sh
disk=$1
k32count=$(ls -l /mnt/ChiaDrive$disk/plots/ | grep plot-k32 | wc -l)
k33count=$(ls -l /mnt/ChiaDrive$disk/plots/ | grep plot-k33 | wc -l)
k34count=$(ls -l /mnt/ChiaDrive$disk/plots/ | grep plot-k34 | wc -l)
echo
echo counting plots on ChiaDrive$disk
echo
echo k32 count = $k32count
echo k33 count = $k33count
echo k34 count = $k34count
