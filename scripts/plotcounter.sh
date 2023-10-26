#!/bin/bash
#    written by Jacob Obrman in June 2021
echo April
for i in {1..9}
do
    cat plotlist | grep "2021-04-0$i" | wc -l
done
for i in {10..31}
do
    cat plotlist | grep "2021-04-$i" | wc -l
done
echo Mai
for i in {1..9}
do
    cat plotlist | grep "2021-05-0$i" | wc -l
done
for i in {10..31}
do
    cat plotlist | grep "2021-05-$i" | wc -l
done
