#!/bin/bash
# Block Spacing (1 Day)
# Build initial data file 

rm -f bs_*_day.dat
echo "plot_bs_day.sh  Block Spacing (720 block look back)"

nblocks=720
bitmarkcli="bitmark-cli -datadir=/home/coins/.bitmark"

max_height="$($bitmarkcli getinfo | grep '"blocks' | awk '{print $3 }' | awk -F  ',' '{print $1 }')"
start_height=$((max_height-nblocks))
echo "from start_height: $start_height  --->   to max height: $max_height"

for algo in {-1..7}
do
    for height in $(seq $start_height $max_height)
    do
        x="$height"
        y="$($bitmarkcli getblockspacing $algo 24 $height | grep average | awk '{ print $5 }')"
        echo "$x $y" >> bs_"$algo"_day.dat
    done
done

mv bs_-1_day.dat bs_day.dat
