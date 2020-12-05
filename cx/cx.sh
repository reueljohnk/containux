#!/bin/bash

optstring=":n:"

while getopts ${optstring} arg; do
  case ${arg} in

    n)
        echo "creating new container for $OPTARG!"
        ;;
    a)
        echo "allowing device for $OPTARG!"
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
