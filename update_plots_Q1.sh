#!/bin/bash

#  mPoW-graphs
#  First Quarter of 8mPoW Blocks
# 450947		2018-Jun-07 04:58:55 First post-fork non Scrypt block (Lyra2REv2) 

#set -e

# Get new time-based folder name
# UnixTimeSTR=$(date "+%s")
UTstr=$(date "+%Y%b%d.%H.%M.%S")
UnixTimeSTR=$UTstr"-Q1"
printf "\nFirst Quarter PLOTS"
printf "\nNew folder for First Quarter  plots: %s" $UnixTimeSTR

# Create folder to hold new set of plots; temporary link as "in-progress"
mkdir $UnixTimeSTR
ln -s $UnixTimeSTR inprog.Q1
cp index.php $UnixTimeSTR
cp day.php $UnixTimeSTR
printf "\nGoing into folder ..."
cd $UnixTimeSTR

echo "Determining latest block ... "
#max_height.MARKS.sh /// use da fish shell !!
bitmarkcli="bitmark-cli -datadir=/home/coins/.bitmark"
start_height=450947
###start_height=$(($max_height-72))
max_height="$($bitmarkcli getinfo | grep '"blocks' | awk '{print $3 }' | awk -F  ',' '{print $1 }')"
echo "Max Height: "$max_height
printf "\nCurrent block height is: %s\n" $max_height

printf "Extracting Data for Plots ...\n"
time ../plot_bs_Q1.sh $start_height $max_height
time ../plot_hr_Q1.sh $start_height $max_height
time ../plot_df_Q1.sh $start_height $max_height
echo "Plotting the Data ..."
time gnuplot ../plot-script-Q1

# Before sleeping, label as latest "Week" set ...
cd ..
  
if [ -e latest.Q1 ] 
then
   if [ -e previo.Q1 ] 
   then
     rm previo.Q1 
   fi
   ln latest.Q1 previo.Q1
   rm latest.Q1
else
   echo "First Run"
fi
printf " if latest.Q1 existed, it is now previo.Q1 \n"
ln -s $UnixTimeSTR latest.Q1

#  and remove inprog.Q1 link
rm inprog.Q1

printf "Done with First Quarter of mPoW Blocks !\n"
