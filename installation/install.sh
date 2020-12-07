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

mkfs.ext4 /dev/vda1
mkswap /dev/vda1
swapon /dev/vda1

# mount filesystems

mount /dev/vda1 /mnt

# install necessary packages
sed 's/\s*#.*//g;/^[[:space:]]*$/d' packages.txt >> packages_clean.txt
tr '\n' ' ' < packages_clean.txt | pacstrap /mnt

# generate the fstab file to boot
genfstab -U /mnt >> /mnt/etc/fstab

#!!!! UNCOMMENT BEFORE EXECUTING!!!!!! 
arch-chroot /mnt << EOF

# set timezone
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime

# sync the hardware clock
hwclock --systohc

# set the locale to US-UTF-8
sed -i '/en_US.UTF-8 UTF-8/s/#//g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# set hostname
echo "conarch" >> /etc/hostname

# configure the hosts file
echo -e "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\tarch.localdomain\t arch" >> /etc/hosts

# Enter password
echo "Enter a password for the root account"
passwd

## Create user
echo -n "Enter username : "
read username
useradd -m -G wheel $username
echo "Enter a password for $username"
passwd $username

# Give full root access to user
sed -i '/root ALL=(ALL) ALL/a \user ALL=(ALL) ALL' /etc/sudoers 

# Give root access to everyone part of the wheel group
#sed -i '/%wheel ALL=(ALL) ALL/s/#//g' /etc/sudoers


#start services
systemctl enable NetworkManager
systemctl enable gdm


# set variables

# bootloader
grub-install --target=i386-pc /dev/vda
grub-mkconfig -o /boot/grub/grub.cfg

sed '/^GRUB_CMDLINE_LINUX_DEFAULT.*/c\GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 quiet apparmor=1 lsm=lockdown,yama,apparmor\"' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# unmount
exit
EOF

reboot