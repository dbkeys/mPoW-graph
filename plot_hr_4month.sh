#!/bin/bash
# HASH RATE

bitmarkcli="bitmark-cli -datadir=/home/coins/.bitmark"
echo $bitmarkcli

rm -f hr_*.dat

#max_height="$($bitmarkcli getinfo | grep '"blocks' | awk '{print $3 }' | awk -F  ',' '{print $1 }')"

# 4 months is about  ~120  days back
# 120 * 720 = 86400   // "A block for every second in a day "
#let block_start=$max_height-86400
block_start=$1
max_height=$2

echo "from: $block_start   ----->  to: $max_height"

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
    for height in $(seq $block_start $max_height)
    do
        x="$height"
        y="$($bitmarkcli getnetworkhashps 24 $height $algo)"
        echo "$x $y" >> hr_$algo.dat
    done
done
