#!/bin/bash

optstring=":n:a:d:l"
FJ_HOME="$HOME/.config/firejail/"

while getopts ${optstring} arg; do
  case ${arg} in

    n)  
        [ -z "$3" ] && echo "please enter name of container" && exit 1

        echo "creating new container for $OPTARG! named $3..."
        touch $FJ_HOME/$3.profile
        echo "include $3.local" >> $FJ_HOME/$3.profile
        echo "include globals.local" >> $FJ_HOME/$3.profile
        echo "------------"
        echo "Successfully created container for $OPTARG, use the -l flag for"

        #cp /etc/firejail/default.profile ~/.config/firejail
        ## change first line
        ;;
    a)
        [ -z "$3" ] && echo "please enter device to allow" && exit 1
        # PERFORM CHECK TO SEE IF $3 and OPTARG is valid
	    tempvar="blacklist\ $3"
	    tempvar=$(echo $tempvar | sed 's/\//\\\//g')
	    tempvar1="$FJ_HOME/$OPTARG.profile"
	    echo $tempvar
	    sed -i /"$tempvar"/d $tempvar1
        echo "allowing $3 for $OPTARG!"
        ;;
    d)
        [ -z "$3" ] && echo "please enter device to deny" && exit 1
        # PERFORM CHECK TO SEE IF $3 and OPTARG is valid
        echo "blacklist $3" >> $FJ_HOME/"$OPTARG".profile
        echo "deny a device for $OPTARG!"
        ;;
    l)
        echo "list containers for $OPTARG!"
        ;;
    :)
        echo "$0: Must supply an argument to -$OPTARG." >&2
        exit 1
        ;;
    ?)
        echo "Invalid option: -${OPTARG}."
        exit 2
        ;;
  esac
done