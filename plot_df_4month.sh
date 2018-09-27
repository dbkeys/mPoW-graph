#!/bin/bash
# Difficulty

bitmarkcli="bitmark-cli -datadir=/home/coins/.bitmark"

echo $bitmarkcli

rm -f df_*.dat

max_height="$($bitmarkcli getinfo | grep '"blocks' | awk '{print $3 }' | awk -F  ',' '{print $1 }')"
# 10 days back
#let block_start=$max_height-7200

#  120 day start
let block_start=$max_height-86400
echo "from: $block_start   ----->  to: $max_height"

for algo in {0..7}
do
    for height in $(seq $block_start $max_height)
    do
        x="$height"
        y="$($bitmarkcli getdifficulty $algo $height | grep difficulty | awk '{ print $3 }')"
        echo "$x $y" >> df_$algo.dat
    done
done
