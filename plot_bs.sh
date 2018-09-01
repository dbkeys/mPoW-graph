#!/bin/bash                                                                                                                   
# Block Spacing

rm -f bs_*.dat
#bitmarkcli="bitmark-cli -datadir=$HOME/.bitmark-main-2"
bitmarkcli="bitmark-cli -datadir=/home/coins/.bitmark"

max_height="$($bitmarkcli getinfo | grep '"blocks' | awk '{print $3 }' | awk -F  ',' '{print $1 }')"

# Famous block in Bitmark History	;)
# 446500
# 458640 = Bitmark day 637 ( start of 637th 720-block period )
# block_start=458640

# 10 days back
# let block_start=$max_height-7200
# 7 days back
let block_start=$max_height-5040

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
