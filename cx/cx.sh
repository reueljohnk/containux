#!/bin/bash

optstring=":n:a:d:l"
FJ_HOME="$HOME/.config/firejail/"

while getopts ${optstring} arg; do
  case ${arg} in

    n)  
        [ -z "$3" ] && echo "Enter name of container" && exit 1

	CX_NAME=$3

        echo "Creating a container for $OPTARG with name $CX_NAME..."

        touch $HOME/.config/firejail/$CX_NAME.profile
	    echo "include $CX_NAME.local" >> ~/.config/firejail/$CX_NAME.profile
        echo "include globals.local" >> ~/.config/firejail/$CX_NAME.profile
        echo "------------"

        echo "Successfully created container for $OPTARG"

        ;;
    a)
        [ -z "$3" ] && echo "please enter device to allow" && exit 1
	    CX_DEVICE=$3
        # PERFORM CHECK TO SEE IF $3 and OPTARG is valid
	    WL_DEVICE="blacklist\ $CX_DEVICE"
	    WL_DEVICE=$(echo $WL_DEVICE | sed 's/\//\\\//g')
	    CX_DEVICE_PATH="$FJ_HOME/$OPTARG.profile"
	    sed -i /"$WL_DEVICE"/d $CX_DEVICE_PATH
        echo "allowing $CX_DEVICE for $OPTARG!"
        ;;
    d)
        [ -z "$3" ] && echo "Enter a device to deny for $OPTARG" && exit 1
        # PERFORM CHECK TO SEE IF $3 and OPTARG is valid
	    CX_DEVICE=$3
        echo "blacklist $CX_DEVICE" >> ~/.config/firejail/"$OPTARG".profile
        echo "Denying access to $CX_DEVICE for $OPTARG"
        ;;
    l)
        echo "Listing all containers"
	    echo "-------"
	    ls -1 $HOME/.config/firejail/ | sed -e 's/\..*$//'
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