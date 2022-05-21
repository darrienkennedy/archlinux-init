#!/bin/bash

## PREREQUISITES ########################################################
#  every installation of arch linux requires these commands be run first.
#########################################################################
#
# timedatectl set-ntp true
# timedatectl set-timezone US/Eastern
#
# fdisk /dev/{device}
#   /dev/{efi_partition}, /mnt/boot, >300M, EFI system partition (EF)
#   /dev/{swap_partition}, [SWAP], >=512M, swap (82)
#   /dev/{root_partition}, /mnt, any, Linux (83)
#
# mkfs.ext4 /dev/{root_partition}
# mkfs.fat -F 32 /dev/{efi_partition}
# mkswap /dev/{swap_partition}
#
# swapon /dev/{swap_partition}
# mount /dev/{efi_partition} /mnt/boot
# mount /dev/{root_partition} /mnt
#
# pacstrap /mnt base linux linux-firmware
# genfstab -U /mnt >> /mnt/etc/fstab
# 
# arch-chroot /mnt
#
# passwd
#
#########################################################################

pacman -S iwd grub efibootmgr vim

ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime
hwclock --systohc

sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/local.conf
echo "KEYMAP=us" > /etc/vconsole.conf

mkdir -p /boot/EFI/GRUB
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

cp conf/iwd.conf /etc/iwd/main.conf
systemctl enable systemd-resolved
systemctl enable iwd

