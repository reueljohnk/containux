# apparmor=1 lsm=lockdown,yama,apparmor
# need to set kernel parameters with sudo ^
# /etc/default/grub
# run grub-mkconfig post that with sudo
# illustrate the docker difference in overhead
# pls dont use it more
# use graphs, what is the difference when you do this. run tests
# arhitectural diagram


# enable print mode
set -o xtrace

#!/bin/bash

# check for a stable internet connection
NET_CON=$(ping -c 0 -q google.com >&/dev/null; echo $?)

if [$NET_CON != -1]; then
    echo "No internet connection... Exiting.."
    exit
fi

# set the time
echo "Setting timezone"
timedatectl set-ntp true

# read the parition table

sfdisk /dev/vda < ./vda.sfdisk

# format partitions

mkfs.ext3 /dev/vda2
mkswap /dev/vda0
swapon /dev/vda0

# mount filesystems

mount /dev/vda1 /mnt

# install necessary packages
# TODO: Convert to csv file and read!

yes ""  | pacstrap /mnt base base-devel linux linux-headers linux-firmware grub networkmanager network-manager-applet wpa_supplicant dialog os-prober mtools dosfstools intel-ucode xf86-video-intel mesa xorg gnome-shell gnome-terminal gdm apparmor vim firejail

# generate the fstab file to boot

genfstab -U /mnt >> /mnt/etc/fstab


# arch-chroot /mnt /bin/bash <<EOF
# pacman -S i3 sddm grub
# ...
# mkinitcpio -p linux
# EOF

#!!!! UNCOMMENT BEFORE EXECUTING!!!!!! arch-chroot /mnt << EOF

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
#echo "Enter username"
#read username
#useradd -m -G wheel $username
#echo "Enter password for $username"
#passwd $username
#
## give root access to  everyone part of the wheel group
#sed -i '/%wheel ALL=(ALL) ALL/s/#//g' /etc/sudoers

#start services
systemctl enable NetworkManager
systemctl enable gdm

# bootloader
grub-install --target=i386-pc /dev/vda
grub-mkconfig -o /boot/grub/grub.cfg

# unmount
exit
EOF

reboot