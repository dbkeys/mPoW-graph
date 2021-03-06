#!/bin/bash

echo "plot_df_day.sh  Difficulty (720 block look back)"
nblocks=720

rm -f df_*_day.dat

bitmarkcli="bitmark-cli -datadir=/home/coins/.bitmark"

max_height="$($bitmarkcli getinfo | grep '"blocks' | awk '{print $3 }' | awk -F  ',' '{print $1 }')"
start_height=$((max_height-nblocks))
echo "from start_height: $start_height  --->   to max height: $max_height"

for algo in {0..7}
do
    for height in $(seq $start_height $max_height)
    do
        x="$height"
        y="$($bitmarkcli getdifficulty $algo $height | grep difficulty | awk '{ print $3 }')"
        echo "$x $y" >> df_"$algo"_day.dat
    done
done
