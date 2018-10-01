#!/bin/bash

echo "Difficulty"

bitmarkcli="bitmark-cli -datadir=/home/coins/.bitmark"

echo $bitmarkcli

rm -f df_*.dat

# start_height and max_height are passed as parameters

let start_height=$1
let max_height=$2
printf "\nfrom: %s ----->  to: %s" $start_height $max_height

for algo in {0..7}
do
    for height in $(seq $start_height $max_height)
    do
        x="$height"
        y="$($bitmarkcli getdifficulty $algo $height | grep difficulty | awk '{ print $3 }')"
        echo "$x $y" >> df_$algo.dat
    done
done
