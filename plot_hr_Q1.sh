#!/bin/bash

echo "HASH RATE"

bitmarkcli="bitmark-cli -datadir=/home/coins/.bitmark"
echo $bitmarkcli

rm -f hr_*.dat

# start_height and max_height are passed as parameters
let start_height=$1
let max_height=$2
printf "\nfrom: %s ----->  to: %s" $start_height $max_height

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
    for height in $(seq $start_height $max_height)
    do
        x="$height"
        y="$($bitmarkcli getnetworkhashps 24 $height $algo)"
        echo "$x $y" >> hr_$algo.dat
    done
done
