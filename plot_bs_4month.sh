#!/bin/bash                                                                                                                   
# Block Spacing

rm -f bs_*.dat
bitmarkcli="bitmark-cli -datadir=/home/coins/.bitmark"

max_height="$($bitmarkcli getinfo | grep '"blocks' | awk '{print $3 }' | awk -F  ',' '{print $1 }')"

# 10 days back
# let block_start=$max_height-7200

# 4 months  ~120  days back
# 120 * 720 = 86400   // "A block for every second in a day "
let block_start=$max_height-86400
echo "from: $block_start   ----->  to: $max_height"

# {-1..7} Algo "-1" means all blocks, regardless of actual algo
# Block spacing overall should average 2 minutes

for algo in {-1..7}
do
    for height in $(seq $block_start $max_height)
    do
        x="$height"
        y="$($bitmarkcli getblockspacing $algo 24 $height | grep average | awk '{ print $5 }')"
        echo "$x $y" >> bs_$algo.dat
    done
done

mv bs_-1.dat bs.dat
