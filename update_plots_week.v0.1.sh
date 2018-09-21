#!/bin/bash

#  Week Plots  (Overall Plots)

#set -e

while true
do
    # Get new time-based folder name
    UnixTimeSTR=$(date "+%s")
    UTstr=$(date "+%Y%b%d.%s")
    UnixTimeSTR=$UTstr"-WEEK"
    printf "\nWEEK PLOTS"
    printf "\nNew folder for Weekly  plots: %s" $UnixTimeSTR

    # Create folder to hold new set of plots; temporary link as "in-progress"
    mkdir $UnixTimeSTR
    ln -s $UnixTimeSTR inprog.WEEK
    cp index.php $UnixTimeSTR
    cp day.php $UnixTimeSTR
    printf "\nGoing into folder ..."
    cd $UnixTimeSTR

    echo "Extracting Data for Plots ..."
    time ../plot_bs.sh
    time ../plot_hr.sh
    time ../plot_df.sh
    echo "Plotting the Data ..."
    time gnuplot ../plot-script

    # Before sleeping, label as latest "Week" set ...
    cd ..
  
    if [ -e latest.WEEK ] 
    then
       if [ -e previo.WEEK ] 
       then
         rm previo.WEEK 
       fi
       ln latest.WEEK previo.WEEK
       rm latest.WEEK
    else
	echo "First Run"
    fi
    printf " latest.WEEK is now previo.WEEK \n"
    ln -s $UnixTimeSTR latest.WEEK

    #  and remove inprog.WEEK link
    rm inprog.WEEK

    # Check on disk space would be useful here ...


    # 5m40s
    # sleep 340
    # 2.4h; 2h 24m;  10 times/day
    #sleep 8640

    # Update Week plots 3 times/day

    printf "Sleeping for 8 hours; (Until $WakeUpTime) \n" 

    UnixTimeSTR=$(date "+%s")
    WakeUpTime=$(($UnixTimeSTR + 28800 ))
    WkUpTmSTR=$(date -d @$WakeUpTime +'%m/%d %H:%M:%S')
    printf "Sleeping for 8 hours; (Until $WkUpTmSTR [$WakeUpTime]) \n"
    sleep 28800

    #echo "Press a key to generate the next set."
    #read -p sumting
done
