#!/bin/bash

set -e

./plot_bs_day.sh
./plot_hr_day.sh
./plot_df_day.sh
echo "Plotting ..."
gnuplot plot-script-day
