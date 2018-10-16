#!/bin/bash                                                                                                                   

echo "Block Spacing"

rm -f bs_*.dat
bitmarkcli="bitmark-cli -datadir=/home/coins/.bitmark"

# block_start and max_height are passed as parameters

let start_height=$1
let max_height=$2
printf "\nfrom: %s ----->  to: %s" $start_height $max_height

# {-1..7} Algo "-1" means all blocks, regardless of actual algo
# Block spacing overall should average 2 minutes

for algo in {-1..7}
do
    for height in $(seq $start_height $max_height)
    do
        x="$height"
        y="$($bitmarkcli getblockspacing $algo 24 $height | grep average | awk '{ print $5 }')"
        echo "$x $y" >> bs_$algo.dat
    done
done

mv bs_-1.dat bs.dat
