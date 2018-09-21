#!/bin/bash
# Block Spacing (1 Day)
# Build initial data file 

# 90 blocks/ hour
# 180 block / 2 hours

rm -f bs_*_2hour.dat
echo "plot_bs_2hour.sh  Block Spacing (60 block look back)"

bitmarkcli="bitmark-cli -datadir=/home/coins/.bitmark"

nblocks=60
max_height="$($bitmarkcli getinfo | grep '"blocks' | awk '{print $3 }' | awk -F  ',' '{print $1 }')"
start_height="$((max_height-nblocks))"
echo "from: $start_height   to: $max_height"

for algo in {-1..7}
do
    for height in $(seq $start_height $max_height)
    do
        x="$height"
        y="$($bitmarkcli getblockspacing $algo 24 $height | grep average | awk '{ print $5 }')"
        echo "$x $y" >> bs_"$algo"_2hour.dat
    done
done

mv bs_-1_2hour.dat bs_2hour.dat
