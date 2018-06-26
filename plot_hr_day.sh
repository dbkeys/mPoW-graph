#!/bin/bash

echo "plot_hr_day.sh  Hash Rate (720 block look back)"
nblocks=720

rm -f hr_*_day.dat

bitmarkcli="bitmark-cli -datadir=/home/coins/.bitmark"

max_height="$($bitmarkcli getinfo | grep '"blocks' | awk '{print $3 }' | awk -F  ',' '{print $1 }')"

# https://chainquery.com/bitcoin-api/getnetworkhashps
# bitmark abbreviation: gnhps
#
#    The getnetworkhashps RPC returns the estimated current or historical network hashes per second,
#  based on the last n blocks.
#
#Parameter #1—number of blocks to average
#Parameter #2—block height
#Parameter #3-algorithm ( 1 of 5 mPoW algos in bitmark; does not exist in bitcoin)
#Result: estimated hashes per second
#
#--------------------------------------------------------------------------------------------------
for algo in {0..7}
do
    start_height=$((max_height-nblocks))
    for height in $(seq $start_height $max_height)
    do
        x="$height"
        y="$($bitmarkcli getnetworkhashps 24 $height $algo)"
        echo "$x $y" >> hr_"$algo"_day.dat
    done
done
