#!/bin/bash

# This script is to make acqparams.txt using json file made by dcm2niix.
# DWIs of reversed phase encoding directions are required.
# Usage: acqparams_maker.sh dwi.json reversed_encoding_dwi.json
# (dwi is always larger than or equal size to reversed_encoding_dwi)
# Note: Here the coordinate system is assumed to be RAS. 
# So phase encoding direction is as follows:
# i	    LR
# i-	RL
# j	    PA
# j-	AP
# k	    IS
# k-	SI
# In most cases of dwi image this is correct, but you may want to check the image with your own eyes.

if [[ -z $1 ]]; then
    echo "Please specify json.file. Usage: acqparams_maker.sh yourjsonfile.jsons"
    exit
elif [[ ! -f $1 ]]; then
    echo "This file does not exist. Please check the path."
    exit
else :
fi

if [[ -z $2 ]]; then
    echo "Please specify json.file. Usage: acqparams_maker.sh yourjsonfile.json"
    exit
elif [[ ! -f $2 ]]; then
    echo "This file does not exist. Please check the path."
    exit
else :
fi

TRT1=$(cat $1 | grep TotalReadoutTime | cut -d: -f2 | tr -d ',')
PED1=$(cat $1 | grep \"PhaseEncodingDirection\"|  cut -d: -f2 | tr -d '," ')
TRT2=$(cat $2 | grep TotalReadoutTime | cut -d: -f2 | tr -d ',')
PED2=$(cat $2 | grep \"PhaseEncodingDirection\"|  cut -d: -f2 | tr -d '," ')
echo "Phase encoding direction is $PED1 and $PED2."
read -p "How many b0s from $1 do you want to use for topup? > " num1
read -p "How many b0s from $2 do you want to use for topup? > " num2


case "$PED1" in
    "i")
        the_1st_row="1 0 0 $TRT1"
        the_2nd_row="-1 0 0 $TRT2"
        ;;
    "i-")
        the_1st_row="-1 0 0 $TRT1"
        the_2nd_row="1 0 0 $TRT2"
        ;;
    "j")
        the_1st_row="0 1 0 $TRT1"
        the_2nd_row="0 -1 0 $TRT2"
        ;;
    "j-")
        the_1st_row="0 -1 0 $TRT1"
        the_2nd_row="0 1 0 $TRT2"
        ;;
    "k")
        the_1st_row="0 0 1 $TRT1"
        the_2nd_row="0 0 -1 $TRT2"
        ;;
    "k-")
        the_1st_row="0 0 -1 $TRT1"
        the_2nd_row="0 0 1 $TRT2"
        ;;
    *)
        echo "Unable to detect phase encoding direction."
        exit
        ;;
esac

for i in $(seq $num1); do
    echo $the_1st_row >> acqparams.txt
done
for j in $(seq $num2); do
    echo $the_2nd_row >> acqparams.txt
done

echo "Successful."
echo "Note that when you will merge b0s for topup --imain, \
the order of files should be $1 first and $2 second."