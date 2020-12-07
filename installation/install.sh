#!/bin/bash

#enable print mode
#set -o xtrace

# check for a stable internet connection
NET_CON=$(ping -c 1 -q google.com >&/dev/null; echo $?)

if [ $NET_CON != 0 ]; then
    echo "No internet connection... Exiting.."
    exit
fi

# set the time
echo "Setting timezone"
timedatectl set-ntp true

# read the parition table
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << FDISK_CMDS  | fdisk /dev/vda
n   #
p   #
    #
    #
+1G #
t   #
82  #
n   #
p   #
    #
    #
    #
a   #
    #
w   #
FDISK_CMDS
# format partitions

mkfs.ext4 /dev/vda2
mkswap /dev/vda1
swapon /dev/vda1

# mount filesystems

mount /dev/vda2 /mnt

# install necessary packages
sed 's/\s*#.*//g;/^[[:space:]]*$/d' packages.txt >> packages_clean.txt
tr '\n' ' ' < packages_clean.txt | pacstrap /mnt

# generate the fstab file to boot
genfstab -U /mnt >> /mnt/etc/fstab

cp install2.sh /mnt

arch-chroot /mnt ./install2.sh