#!/bin/bash

# mPoW-graph
# 1-Day Look-Back Graphs 

#set -e

while true
do
    # Get new time-based folder name
    UnixTimeSTR=$(date "+%s")
    UTstr=$(date "+%Y%b%d.%H%M%S")
    UnixTimeSTR=$UTstr"-DAY"
    printf "\nDAY PLOTS"
    printf "\nNew folder for day plots: %s" $UnixTimeSTR
    mkdir $UnixTimeSTR
    ln -s $UnixTimeSTR inprog.DAY
    ##cp index.php $UnixTimeSTR
    cp day.php $UnixTimeSTR/index.php
    printf "\nGoing into folder ..."
    cd $UnixTimeSTR

    echo "Extracting Data for Day Plots ..."
    time ../plot_bs_day.sh
    time ../plot_hr_day.sh
    time ../plot_df_day.sh
    echo "Plotting Data ..."
    time gnuplot ../plot-script-day
    printf "Done ! ...\n"
    
    # Before sleeping, label new folder as latest set of "day" graphs ...
    cd ..
    if [ -e latest.DAY ]
    then
       if [ -e previo.DAY ]
       then
         rm previo.DAY
       fi
       ln latest.DAY previo.DAY
       printf " latest.DAY is now previo.DAY \n"
       rm latest.DAY
    else
       echo "First Run"
    fi
    ln -s $UnixTimeSTR latest.DAY

    #  and remove inprog.DAY link
    rm inprog.DAY

    # Check on disk space would be useful here ...

    # 5m40s
    #sleep 340

    #2.4h; 2h 24m; 10 times/day
    #sleep 8640

    # 6 times / day
    # Update Daily plots 6 times/day
    UnixTimeSTR=$(date "+%s")
    WakeUpTime=$(($UnixTimeSTR + 14400 ))
    WkUpTmSTR=$(date -d @$WakeUpTime +'%m/%d %H:%M:%S')
    printf "Sleeping for 4 hours; (Until $WkUpTmSTR [$WakeUpTime]) \n"
    sleep 14400

done
