#!/bin/bash
# setrootdev.sh -- set the root device in Image file
# author: falcon <wuzhangjin@gmail.com>
# update: 2008-12-25

#
# ROOT_DEV specifies the default root-device when making the image.
# This can be either FLOPPY, /dev/xxxx or empty, in which case the
# default of /dev/hd6 is used by 'build'.
#
# ramfs: 0000
# Floppy B: 021d
# hd1: 0301
IMAGE=$1
root_dev=$2
ram_img=$3

# by default, using the integrated floppy including boot & root image
# set the default "device" file for root image file
# DEFAULT_MAJOR_ROOT=0
# DEFAULT_MINOR_ROOT=0
if [ -z "$root_dev" ]; then
	DEFAULT_MAJOR_ROOT=3
	DEFAULT_MINOR_ROOT=1
else
	DEFAULT_MAJOR_ROOT=${root_dev:0:2}
	DEFAULT_MINOR_ROOT=${root_dev:2:3}
fi

# Set "device" for the root image file
echo -ne "\x$DEFAULT_MINOR_ROOT\x$DEFAULT_MAJOR_ROOT" | dd ibs=1 obs=1 count=2 seek=508 of=$IMAGE conv=notrunc  2>&1 >/dev/null

# Write Ramdisk RootFS
if [ -n "$ram_img" -a -f "$ram_img" ]; then
	dd if=$ram_img seek=256 bs=1024 of=$IMAGE conv=notrunc 2>&1 >/dev/null
fi
