#!/bin/bash

#  mPoW-graphs
#  One Month - 32-day Look-Back Graphs  (Overall Plots)

#set -e

while true
do
    # Get new time-based folder name
    UnixTimeSTR=$(date "+%s")
    UTstr=$(date "+%Y%b%d.%s")
    UnixTimeSTR=$UTstr"-MONTH"
    printf "\nMONTH PLOTS"
    printf "\nNew folder for Weekly  plots: %s" $UnixTimeSTR

    # Create folder to hold new set of plots; temporary link as "in-progress"
    mkdir $UnixTimeSTR
    ln -s $UnixTimeSTR inprog.MONTH
    cp index.php $UnixTimeSTR
    printf "\nGoing into folder ..."
    cd $UnixTimeSTR

    echo "Extracting Data for Plots ..."
    time ../plot_bs_month.sh
    time ../plot_hr_month.sh
    time ../plot_df_month.sh
    echo "Plotting the Data ..."
    time gnuplot ../plot-script-month

    # Before sleeping, label as latest "Week" set ...
    cd ..
  
    if [ -e latest.MONTH ] 
    then
       if [ -e previo.MONTH ] 
       then
         rm previo.MONTH 
       fi
       ln latest.MONTH previo.MONTH
       rm latest.MONTH
    else
	echo "First Run"
    fi
    printf " latest.MONTH is now previo.MONTH \n"
    ln -s $UnixTimeSTR latest.MONTH

    #  and remove inprog.MONTH link
    rm inprog.MONTH

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
