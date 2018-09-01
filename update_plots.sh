#!/bin/bash

set -e

while true
do
    UnixTimeSTR=$(date "+%s")
    UTstr=$(date "+%Y%b%d.%s")
    UnixTimeSTR=$UTstr
    mkdir $UnixTimeSTR
    cp index.php $UnixTimeSTR
    cd $UnixTimeSTR

    echo "Extracting Data for Plots ..."
    ../plot_bs.sh
    ../plot_hr.sh
    ../plot_df.sh
    echo "Plotting Data ..."
    gnuplot ../plot-script
    cd ..

    # Before sleeping, label as latest ...
    rm latest
    ln -s $UnixTimeSTR latest

    # 5m40s
    # sleep 340

    # 2h 24m
    sleep 8640
done
