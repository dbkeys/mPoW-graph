#!/bin/bash

set -e

while true
do
    ./plot_bs.sh
    ./plot_hr.sh
    ./plot_df.sh
    gnuplot plot-script
    # 5m40s
#    sleep 340
done
