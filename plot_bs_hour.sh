#!/bin/bash
# Block Spacing (1 Day)
# Build initial data file 

# 90 blocks/ hour

rm -f bs_*_hour.dat
echo "plot_bs_hour.sh  Block Spacing (90 block look back)"

nblocks=90
bitmarkcli="bitmark-cli -datadir=/home/coins/.bitmark"

max_height="$($bitmarkcli getinfo | grep '"blocks' | awk '{print $3 }' | awk -F  ',' '{print $1 }')"

for algo in {-1..7}
do
    start_height=$((max_height-nblocks))
    for height in $(seq $start_height $max_height)
    do
        x="$height"
        y="$($bitmarkcli getblockspacing $algo 24 $height | grep average | awk '{ print $5 }')"
        echo "$x $y" >> bs_"$algo"_hour.dat
    done
done

mv bs_-1_hour.dat bs_hour.dat
