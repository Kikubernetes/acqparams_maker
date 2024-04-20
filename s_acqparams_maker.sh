#!/bin/bash

# This script is to make acqparams.txt for topup using json file(s) made by dcm2niix.

# Usage: acqparams_maker.sh dwi.json (reversed_encoding_dwi.json)

# If you have paired PE and want to use more than 1 b0 for topup, 
# put the number of b0s after the json file's path. For example,
# acqparams_maker.sh dwi.json reversed_encoding_dwi.json 3 3

# Phase encoding direction is assumed to be as follows:
# i	LR
# i-	RL
# j	PA
# j-	AP
# k	IS
# k-	SI
# Though in most cases this is correct, you may want to check the image with your own eyes.
set -x

# Check if the argument is correct
if [[ $# -lt 1 ]]; then
    echo "Usage: acqparams_maker.sh dwi.json (reversed_encoding_dwi.json)"
    exit 1
fi

# Check if the json file exists
if [[ ! -e $1 ]]; then
    echo "Something wrong. Check the path of the json file."
    exit 1
fi

# default value
pairedPE=0

# Check json file(s) to know if paired phase encodings exist.
if [[ ! -z $2 ]]; then
    # Check if the 2nd json file exists
    if [[ ! -e $2 ]]; then
        echo "Something wrong. Check the path of the 2nd json file."
        exit 1
    else
        pairedPE=1
    fi
fi

# If phase encoding is two directions, make acqparams.txt for topup.
if [[ $pairedPE -eq 1 ]]; then

    TRT1=$(cat $1 | grep TotalReadoutTime | cut -d: -f2 | tr -d ',')
    PED1=$(cat $1 | grep \"PhaseEncodingDirection\"|  cut -d\" -f4 | tr -d ',' )
    TRT2=$(cat $2 | grep TotalReadoutTime | cut -d: -f2 | tr -d ',')
    PED2=$(cat $2 | grep \"PhaseEncodingDirection\"|  cut -d\" -f4 | tr -d ',' )
    echo "Phase encoding direction is $PED1 and $PED2."
    
    case $PED1 in
        i)
            the_1st_row="1 0 0 $TRT1"
            the_2nd_row="-1 0 0 $TRT2"
            ;;
        i-)
            the_1st_row="-1 0 0 $TRT1"
            the_2nd_row="1 0 0 $TRT2"
            ;;
        j)
            the_1st_row="0 1 0 $TRT1"
            the_2nd_row="0 -1 0 $TRT2"
            ;;
        j-)
            the_1st_row="0 -1 0 $TRT1"
            the_2nd_row="0 1 0 $TRT2"
            ;;
        k)
            the_1st_row="0 0 1 $TRT1"
            the_2nd_row="0 0 -1 $TRT2"
            ;;
        k-)
            the_1st_row="0 0 -1 $TRT1"
            the_2nd_row="0 0 1 $TRT2"
            ;;
        *)
            echo "Unable to detect phase encoding direction."
            exit
            ;;
    esac
     
     # get the number of b0(s), default is 1
    num1=1
    num2=1
    if [[ ! -z $3 && ! -z $4 ]]; then
       num1=$3
       num2=$4
    fi
    
    for i in $(seq $num1); do
        echo $the_1st_row >> acqparams.txt
    done
    for j in $(seq $num2); do
        echo $the_2nd_row >> acqparams.txt
    done
    
fi

# if pahse encoding is one direction, make acqparams for synb0.
if [[ $pairedPE -eq 0 ]]; then
    TRT1=$(cat $1 | grep TotalReadoutTime | cut -d: -f2 | tr -d ',')
    PED1=$(cat $1 | grep \"PhaseEncodingDirection\"|  cut -d\" -f4 | tr -d ',' )
    echo "Phase encoding direction is $PED1."
    
    case $PED1 in
        i)
            the_1st_row="1 0 0 $TRT1"
            the_2nd_row="-1 0 0 0"
            ;;
        i-)
            the_1st_row="-1 0 0 $TRT1"
            the_2nd_row="1 0 0 0"
            ;;
        j)
            the_1st_row="0 1 0 $TRT1"
            the_2nd_row="0 -1 0 0"
            ;;
        j-)
            the_1st_row="0 -1 0 $TRT1"
            the_2nd_row="0 1 0 0"
            ;;
        k)
            the_1st_row="0 0 1 $TRT1"
            the_2nd_row="0 0 -1 0"
            ;;
        k-)
            the_1st_row="0 0 -1 $TRT1"
            the_2nd_row="0 0 1 0"
            ;;
        *)
            echo "Unable to detect phase encoding direction."
            exit
            ;;
    esac
    
    num1=1
    num2=1
    
    i=0
    while [[ $i -lt $num1 ]]; do
        echo $the_1st_row >> acqparams.txt
        i=$((i + 1))
    done
    j=0
    while [[ $j -lt $num2 ]]; do
        echo $the_2nd_row >> acqparams.txt
        j=$((j + 1))
    done
    
    
#    for i in $(seq $num1); do
#        echo $the_1st_row >> acqparams.txt
#    done
#    for j in $(seq $num2); do
#        echo $the_2nd_row >> acqparams.txt
#    done
    
fi
exit
