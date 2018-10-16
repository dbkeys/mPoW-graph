#!/bin/bash

#  mPoW-graphs
#  One Month - 120-day Look-Back Graphs  (4-Month Plot)

#set -e

while true
do
    # Get new time-based folder name
    UnixTimeSTR=$(date "+%s")
    UTstr=$(date "+%Y%b%d.%s")
    UnixTimeSTR=$UTstr"-4MONTH"
    printf "\n4MONTH PLOTS"
    printf "\nNew folder for Weekly  plots: %s" $UnixTimeSTR

    # Create folder to hold new set of plots; temporary link as "in-progress"
    mkdir $UnixTimeSTR
    ln -s $UnixTimeSTR inprog.4MONTH
    cp index.php $UnixTimeSTR
    cp day.php $UnixTimeSTR
    printf "\nGoing into folder ..."
    cd $UnixTimeSTR

    # Refactor calculation of start & end blocks ourside of blockspacing, hashrate and difficulty scripts
    # Excution time of them is such that latest block will change ! Determine at this point for consistency.
    echo "Determining latest block ... "
    bitmarkcli="bitmark-cli -datadir=/home/coins/.bitmark"
    max_height="$($bitmarkcli getinfo | grep '"blocks' | awk '{print $3 }' | awk -F  ',' '{print $1 }')"
    ### start_height=450947 // example fixed start height: start of mPoW blocks
    # 4 months is about  ~120  days back
    # 120 * 720 = 86400   // "A block for every second in a day "
    let start_height=$max_height-86400

    BgnTimSTR=$(date "+%Y%b%d_%H:%M:%S")
    printf "%s - Extracting Data for Plots ...\n" $BgnTimSTR
    time ../plot_bs_4month.sh $start_height $max_height
    time ../plot_hr_4month.sh $start_height $max_height
    time ../plot_df_4month.sh $start_height $max_height

    echo "Plotting the Data ..."
    time gnuplot ../plot-script-4month

    # Before sleeping, label as latest "Week" set ...
    cd ..
  
    if [ -e latest.4MONTH ] 
    then
       if [ -e previo.4MONTH ] 
       then
         rm previo.4MONTH 
       fi
       ln latest.4MONTH previo.4MONTH
       rm latest.4MONTH
    else
	echo "First Run"
    fi
    printf " latest.4MONTH is now previo.4MONTH \n"
    ln -s $UnixTimeSTR latest.4MONTH

    #  and remove inprog.4MONTH link
    rm inprog.4MONTH

    # Check on disk space would be useful here ...


    # // At this interval, perhaps best served by cron entry
    # Update 4MONTH plots 1 time/ week (4x/month)

    printf "Sleeping for 7 days (Until $WakeUpTime) \n" 

    UnixTimeSTR=$(date "+%s")
    WakeUpTime=$(($UnixTimeSTR + 604800 ))
    WkUpTmSTR=$(date -d @$WakeUpTime +'%m/%d %H:%M:%S')
    printf "Sleeping for 7 days; (Until $WkUpTmSTR [$WakeUpTime]) \n"
    sleep 604800

    #echo "Press a key to generate the next set."
    #read -p sumting
done
