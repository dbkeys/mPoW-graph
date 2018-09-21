#!/bin/bash
# Block Spacing (1 Day)
# Build initial data file 

#  30 blocks/ hour
#  60 block / 2 hours
# 120 block / 4 hours

rm -f bs_*_4hour.dat
echo "plot_bs_4hour.sh  Block Spacing (120 block look back)"

bitmarkcli="bitmark-cli -datadir=/home/coins/.bitmark"

nblocks=120
max_height="$($bitmarkcli getinfo | grep '"blocks' | awk '{print $3 }' | awk -F  ',' '{print $1 }')"
start_height="$((max_height-nblocks))"
echo "from: $start_height   to: $max_height"

for algo in {-1..7}
do
    for height in $(seq $start_height $max_height)
    do
        x="$height"
        y="$($bitmarkcli getblockspacing $algo 24 $height | grep average | awk '{ print $5 }')"
        echo "$x $y" >> bs_"$algo"_4hour.dat
    done
done

mv bs_-1_4hour.dat bs_4hour.dat
