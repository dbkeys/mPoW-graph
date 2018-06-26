#!/bin/bash

set -e

while true
do
    ./plot_bs_day.sh
    ./plot_hr_day.sh
    ./plot_df_day.sh
    gnuplot plot-script-day
    # 5m40s
    sleep 340
done
