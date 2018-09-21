#!/bin/bash

#  30  blocks / hour
#  60  blocks / 2-hours
# 120  blocks / 4-hours
# 720 blocks / day

echo "plot_hr_4hour.sh  Hash Rate (120 block look back)"
nblocks=120

rm -f hr_*_4hour.dat

bitmarkcli="bitmark-cli -datadir=/home/coins/.bitmark"

max_height="$($bitmarkcli getinfo | grep '"blocks' | awk '{print $3 }' | awk -F  ',' '{print $1 }')"
start_height=$((max_height-nblocks))
echo "from: $start_height   to: $max_height"

# https://chainquery.com/bitcoin-api/getnetworkhashps
# bitmark abbreviation: gnhps
#
#    The getnetworkhashps RPC returns the estimated current or historical network hashes per second,
#  based on the last n blocks.
#
#Parameter #1—number of blocks to average
#Parameter #2—block height
#Parameter #3-algorithm ( 1 of 8 mPoW algos in bitmark; does not exist in bitcoin)
#Result: estimated hashes per second
#
#--------------------------------------------------------------------------------------------------
for algo in {0..7}
do
    for height in $(seq $start_height $max_height)
    do
        x="$height"
        y="$($bitmarkcli getnetworkhashps 24 $height $algo)"
        echo "$x $y" >> hr_"$algo"_4hour.dat
    done
done
