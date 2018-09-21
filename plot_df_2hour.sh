#!/bin/bash

# 30  blocks / hour
# 60  blocks / 2-hours
# 720 blocks / day

echo "2-Hour  -  plot_df_2hour.sh  Difficulty (60 block look back)"
nblocks=60

rm -f df_*_2hour.dat

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
        echo "$x $y" >> df_"$algo"_2hour.dat
    done
done
