# apparmor=1 lsm=lockdown,yama,apparmor
# need to set kernel parameters with sudo ^
# /etc/default/grub
# run grub-mkconfig post that with sudo
# illustrate the docker difference in overhead
# pls dont use it more
# use graphs, what is the difference when you do this. run tests
# arhitectural diagram


# Set timezone
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime

# hardware clock
hwclock --systohc

# Locale
sed  -i '/en_US.UTF-8 UTF-8/s/#//g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# set hostname
echo "conarch" >> /etc/hostname

# hosts file
echo -e "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\tarch.localdomain\t arch" >> /etc/hosts

# Enter password
echo "Enter root password\n"
passwd

# Create user
echo "Enter username"
read username
useradd -m -G wheel $username
echo "Enter password for $username"
passwd $username

# give root access to  everyone part of the wheel group
sed -i '/%wheel ALL=(ALL) ALL/s/#//g' /etc/sudoers

#start services
systemctl enable NetworkManager
systemctl enable gdm

# bootloader
grub-install --target=i386-pc /dev/vda
grub-mkconfig -o /boot/grub/grub.cfg

# unmount
exit
reboot