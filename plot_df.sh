#!/bin/bash
# Difficulty

#bitmarkcli="bitmark-cli -datadir=$HOME/.bitmark-main-2"
bitmarkcli="bitmark-cli -datadir=/home/coins/.bitmark"

echo $bitmarkcli

rm -f df_*.dat

max_height="$($bitmarkcli getinfo | grep '"blocks' | awk '{print $3 }' | awk -F  ',' '{print $1 }')"
#block_start=460800
# 10 days back
#let block_start=$max_height-7200

#  7 day start
let block_start=$max_height-5040

# 458640 start of Bitmark 637th 720-block period

for algo in {0..7}
do
    for height in $(seq $block_start $max_height)
    do
        x="$height"
        y="$($bitmarkcli getdifficulty $algo $height | grep difficulty | awk '{ print $3 }')"
        echo "$x $y" >> df_$algo.dat
    done
done
