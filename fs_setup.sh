#!/bin/bash

# Check internet
ping -c 3 www.archlinux.org

# Set time
echo "Setting timezone"
timedatectl set-ntp true

# Read parition table

sfdisk /dev/vda < ./vda.sfdisk

# Format partitions

mkfs.ext4 /dev/vda2
mkswap /dev/vda1
swapon /dev/vda1

# Mount filesystem

mount /dev/vda2 /mnt

# Pacstrap

yes ""  | pacstrap /mnt base base-devel linux linux-headers linux-firmware grub networkmanager network-manager-applet wpa_supplicant dialog os-prober mtools dosfstools intel-ucode xf86-video-intel mesa xorg gnome-shell gnome-terminal gdm apparmor vim

# fstab

genfstab -U /mnt >> /mnt/etc/fstab

# exit

arch-chroot /mnt