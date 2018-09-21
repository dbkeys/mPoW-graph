#!/bin/bash

# 4-Hour Graphs 

#set -e

while true
do
    # Get new time-based folder name
    UnixTimeSTR=$(date "+%s")
    # date "+%Y%b%d.%T" 
    #   2018Sep13.09:45:22
    # date "+%Y%b%d.%H:%M"
    #   2018Sep13.09:47
    ## UTstr=$(date "+%Y%b%d.%s")
    UTstr=$(date "+%Y%b%d.%H%M%S")
    UnixTimeSTR=$UTstr"-4HOUR"
    printf "\n4-HOUR PLOTS"
    printf "\nNew folder for 4hour 120-block  plots: %s" $UnixTimeSTR
    mkdir $UnixTimeSTR
    ln -s $UnixTimeSTR inprog.4HOUR
    ##cp index.php $UnixTimeSTR
    cp 4hour.php $UnixTimeSTR/index.php
    printf "\nGoing into folder ..."
    cd $UnixTimeSTR

    echo "Extracting Data for Plots ..."
    time ../plot_bs_4hour.sh
    time ../plot_hr_4hour.sh
    time ../plot_df_4hour.sh
    echo "Plotting Data ..."
    time gnuplot ../plot-script-4hour
    printf "Done ! ...\n"
    
    # Before sleeping, label new folder as latest set of "4hour" graphs ...
    cd ..
    if [ -e latest.4HOUR ]
    then
       if [ -e previo.4HOUR ]
       then
         rm previo.4HOUR
       fi
       ln latest.4HOUR previo.4HOUR
       rm latest.4HOUR
    else
       echo "First Run"
    fi
    printf " latest.4HOUR is now previo.4HOUR \n"
    ln -s $UnixTimeSTR latest.4HOUR

    #  and remove inprog.4HOUR link
    rm inprog.4HOUR

    # Check on disk space would be useful here ...

    # 5m40s
    #sleep 340
    #2.4h; 2h 24m; 10 times/hour

    # Update 4-hour plots about every 15 minutes
    echo  "Sleeping 15 minutes.... "
    UnixTimeSTR=$(date "+%s")
    WakeUpTime=$(($UnixTimeSTR + 900 ))
    WkUpTmSTR=$(date -d @$WakeUpTime +'%m/%d %H:%M:%S')
    printf "Sleeping for 1/4 hours; (Until $WkUpTmSTR [$WakeUpTime]) \n"
    sleep 900

    #sleep 3598   // once an hour
done
