#!/bin/bash

#set -e

while true
do
    # Get new time-based folder name
    UnixTimeSTR=$(date "+%s")
    UTstr=$(date "+%Y%b%d.%s")
    UnixTimeSTR=$UTstr"-HOUR"
    printf "\nHOUR PLOT"
    printf "\nNew folder for hour plots: %s" $UnixTimeSTR
    mkdir $UnixTimeSTR
    ln -s $UnixTimeSTR inprog.HOUR
    ##cp index.php $UnixTimeSTR
    cp hour.php $UnixTimeSTR/index.php
    printf "\nGoing into folder ..."
    cd $UnixTimeSTR

    echo "Extracting Data for Plots ..."
    time ../plot_bs_hour.sh
    time ../plot_hr_hour.sh
    time ../plot_df_hour.sh
    echo "Plotting Data ..."
    time gnuplot ../plot-script-hour
    printf "Done ! ...\n"
    
    # Before sleeping, label new folder as latest set of "hour" graphs ...
    cd ..
    if [ -e latest.HOUR ]
    then
       if [ -e previo.HOUR ]
       then
         rm previo.HOUR
       fi
       ln latest.HOUR previo.HOUR
       rm latest.HOUR
    else
       echo "First Run"
    fi
    printf " latest.HOUR is now previo.HOUR \n"
    ln -s $UnixTimeSTR latest.HOUR

    #  and remove inprog.HOUR link
    rm inprog.HOUR

    # Check on disk space would be useful here ...

    # 5m40s
    #sleep 340
    #2.4h; 2h 24m; 10 times/hour
    # 8640

    # Update 2-hour plots about every hour 
    UnixTimeSTR=$(date "+%s")
    WakeUpTime=$(($UnixTimeSTR + 3598 ))
    WkUpTmSTR=$(date -d @$WakeUpTime +'%m/%d %H:%M:%S')
    printf "Sleeping for a bit less than an hour; (Until $WkUpTmSTR [$WakeUpTime]) \n"
    sleep 3598

done
