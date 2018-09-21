#!/bin/bash

# mPoW-graph
# 2-Hour Look-Back Graphs 

#set -e

while true
do
    # Get new time-based folder name
    UnixTimeSTR=$(date "+%s")
    UTstr=$(date "+%Y%b%d.%s")
    UnixTimeSTR=$UTstr"-2HOUR"
    printf "\n2-HOUR PLOTS"
    printf "\nNew folder for 2hour 60-block  plots: %s" $UnixTimeSTR
    mkdir $UnixTimeSTR
    ln -s $UnixTimeSTR inprog.2HOUR
    ##cp index.php $UnixTimeSTR
    cp 2hour.php $UnixTimeSTR/index.php
    printf "\nGoing into folder ..."
    cd $UnixTimeSTR

    echo "Extracting Data for Plots ..."
    time ../plot_bs_2hour.sh
    time ../plot_hr_2hour.sh
    time ../plot_df_2hour.sh
    echo "Plotting Data ..."
    time gnuplot ../plot-script-2hour
    printf "Done ! ...\n"
    
    # Before sleeping, label new folder as latest set of "2hour" graphs ...
    cd ..
    if [ -e latest.2HOUR ]
    then
       if [ -e previo.2HOUR ]
       then
         rm previo.2HOUR
       fi
       ln latest.2HOUR previo.2HOUR
       printf " latest.2HOUR is now previo.2HOUR \n"
       rm latest.2HOUR
    else
       echo "First Run"
    fi
    ln -s $UnixTimeSTR latest.2HOUR

    #  and remove inprog.2HOUR link
    rm inprog.2HOUR

    # Check on disk space would be useful here ...

    # 5m40s
    #sleep 340
    #2.4h; 2h 24m; 10 times/hour

    # Update 2-hour plots about every 15 minutes
    UnixTimeSTR=$(date "+%s")
    WakeUpTime=$(($UnixTimeSTR + 900 ))
    WkUpTmSTR=$(date -d @$WakeUpTime +'%m/%d %H:%M:%S')
    printf "Sleeping for 1/4 hours; (Until $WkUpTmSTR [$WakeUpTime]) \n"
    sleep 900

    #sleep 3598   // once an hour
done
