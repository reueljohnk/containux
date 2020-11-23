#!/bin/bash

# NEED TO EDIT POST MAKEFILE !

git clone https://github.com/itsrjk/containux.git

chmod -R +x containux/

cd containux/

./fs_setup.sh

arch-chroot /mnt && ./config_setup.sh