#!/bin/bash

#  30  blocks / hour
#  60  blocks / 2-hours
# 120  blocks / 4-hours
# 720 blocks / day

echo "4-Hour  -  plot_df_4hour.sh  Difficulty (120 block look back)"
nblocks=120

rm -f df_*_4hour.dat

bitmarkcli="bitmark-cli -datadir=/home/coins/.bitmark"

max_height="$($bitmarkcli getinfo | grep '"blocks' | awk '{print $3 }' | awk -F  ',' '{print $1 }')"
start_height=$((max_height-nblocks))
echo "from: $start_height   to: $max_height"

for algo in {0..7}
do
    for height in $(seq $start_height $max_height)
    do
        x="$height"
        y="$($bitmarkcli getdifficulty $algo $height | grep difficulty | awk '{ print $3 }')"
        echo "$x $y" >> df_"$algo"_4hour.dat
    done
done
