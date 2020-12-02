#!/bin/bash

# check for a stable internet connection
NET_CON=$(ping -c 1 -q google.com >&/dev/null; echo $?)

if [$NET_CON != 0]; then
    echo "No internet connection... Exiting.."
    exit
fi

# set the time
echo "Setting timezone"
timedatectl set-ntp true

# read the parition table

sfdisk /dev/vda < ./vda.sfdisk

# format partitions

mkfs.ext4 /dev/vda2
mkswap /dev/vda1
swapon /dev/vda1

# mount filesystems

mount /dev/vda2 /mnt

# install necessary packages
# TODO: Convert to csv file and read!

yes ""  | pacstrap /mnt base base-devel linux linux-headers linux-firmware grub networkmanager network-manager-applet wpa_supplicant dialog os-prober mtools dosfstools intel-ucode xf86-video-intel mesa xorg gnome-shell gnome-terminal gdm apparmor vim firejail

# generate the fstab file to boot

genfstab -U /mnt >> /mnt/etc/fstab

# exit

arch-chroot /mnt
