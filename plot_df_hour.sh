#!/bin/bash

# 30 blocks / hour
# 720 blocks / day

nblocks=30
echo "plot_df_hour.sh  Difficulty ($nblocks block look back)"

rm -f df_*_hour.dat

bitmarkcli="bitmark-cli -datadir=/home/coins/.bitmark"

max_height="$($bitmarkcli getinfo | grep '"blocks' | awk '{print $3 }' | awk -F  ',' '{print $1 }')"

for algo in {0..7}
do
    start_height=$((max_height-nblocks))
    for height in $(seq $start_height $max_height)
    do
        x="$height"
        y="$($bitmarkcli getdifficulty $algo $height | grep difficulty | awk '{ print $3 }')"
        echo "$x $y" >> df_"$algo"_hour.dat
    done
done
