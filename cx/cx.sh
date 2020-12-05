#!/bin/bash

optstring=":n:"

while getopts ${optstring} arg; do
  case ${arg} in

    n)  
        [ -z "$3" ] && echo "please enter name of container" && exit 1

        echo "creating new container for $OPTARG! named $3..."
        touch "~/.config/firejail/$3.profile"
        echo "include $3.local" >> "$3.profile"
        echo "include globals.local" >> "$3.profile"
        echo "------------"
        echo "Successfully created container for $OPTARG, use the -l flag for"

        #cp /etc/firejail/default.profile ~/.config/firejail
        ## change first line
        ;;
    a)
        [ -z "$3" ] && echo "please enter device to allow" && exit 1
        # PERFORM CHECK TO SEE IF $3 and OPTARG is valid
        sed -i "/blacklist $3/d" ~/.config/firejail/"$OPTARG".profile
        echo "allowing $3 for $OPTARG!"
        ;;
    d)
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
