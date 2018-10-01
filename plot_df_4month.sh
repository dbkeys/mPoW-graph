#!/bin/bash
# Difficulty

bitmarkcli="bitmark-cli -datadir=/home/coins/.bitmark"

rm -f df_*.dat

# 4 months is about  ~120  days back
# 120 * 720 = 86400   // "A block for every second in a day "
#let block_start=$max_height-86400
block_start=$1
max_height=$2

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
