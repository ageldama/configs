#!/bin/bash
# irandr.sh, by Dale Gass (dale@gass.ca)
# Wed Apr 10 16:43:22 EDT 2019
#
# https://unix.stackexchange.com/questions/97721/how-to-change-the-xorg-gamma-brightness

# Process arguments
if [ "$1" != "" ]
then
    output="$1"
else
    echo "Usage: irandr.sh <outputname> [-setonly]"
    echo "(Settings saved to ~/.xrandr-<outputname>.dat)"
    echo
    echo "Valid outputs:"
    xrandr | egrep -v '^( |Screen)'
    exit 1
fi
setonly=0
if [ "$2" = "-setonly" ]; then setonly=1; fi

# Initialize variables, read for dotfile if exists
cmdhelp="d/f/D/F=brightness j/k/J/K=gamma r=reset s=save l=load q=quit"
brightness=100
gamma=100
dotfile=~/.irandr-"$output".dat
if [ -s "$dotfile"  ]; then read brightness gamma <"$dotfile"; fi
if [ $setonly -eq 0 ]; then 
    echo $cmdhelp
    stty -echo raw intr $'\000' # Allow single character input
fi

# Main loop for setting adjustment
echo 'Bright Gamma'
while :
do
    b=$(bc <<< "scale=2; $brightness/100")  # Make 0.0-1.0
    g=$(bc <<< "scale=2; $gamma/100")
    xrandr --output "$output" --brightness "$b" --gamma "$g:$g:$g"
    printf "\r%4d %4d " $brightness $gamma
    if [ $setonly -eq 1 ]; then echo; exit 0; fi

    read -n1 ch     # Get input character from user
    case $ch in
    d) let brightness=brightness-5;; D) let brightness=brightness-1;;
    f) let brightness=brightness+5;; F) let brightness=brightness+1;;
    j) let gamma=gamma-5;;           J) let gamma=gamma-1;;
    k) let gamma=gamma+5;;           K) let gamma=gamma+1;;
    r) brightness=100; gamma=100;;
    s) echo "$brightness    $gamma" >"$dotfile" && echo -e "Saved\r";;
    l) read brightness gamma <"$dotfile"     && echo -e "Loaded\r";;
    q|$'\003') break;;
    *) echo -e "$cmdhelp\r";;
    esac
done

stty echo -raw intr $'\003' # Undo single character input
