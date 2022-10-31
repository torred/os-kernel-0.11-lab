#!/bin/bash
# build.sh -- a shell version of build.c for the new bootsect.s & setup.s
# author: falcon <wuzhangjin@gmail.com>
# update: 2008-10-10

bootsect=$1
setup=$2
system=$3
IMAGE=$4
# root_dev=$5 挪到setrootdev.sh
# swap_dev=$6 挪到setrootdev.sh

# Set the biggest sys_size
# Changes from 0x20000 to 0x30000 by tigercn to avoid oversized code.
SYS_SIZE=$((0x3000*16))
# SYS_SIZE=$((256*1024))  # 256*1024=0x40000

##############     挪到setrootdev.sh   ################
# set the default "device" file for root image file 
# if [ -z "$root_dev" ]; then
# 	DEFAULT_MAJOR_ROOT=3
#	DEFAULT_MINOR_ROOT=1
# else
#	DEFAULT_MAJOR_ROOT=${root_dev:0:2}
#	DEFAULT_MINOR_ROOT=${root_dev:2:3}
# fi

# if [ -z "$swap_dev" ]; then
#	DEFAULT_MAJOR_SWAP=3
#	DEFAULT_MINOR_SWAP=4
# else
#	DEFAULT_MAJOR_SWAP=${swap_dev:0:2}
#	DEFAULT_MINOR_SWAP=${swap_dev:2:3}
# fi

#	DEFAULT_MAJOR_ROOT=2
#	DEFAULT_MINOR_ROOT=1c
#	DEFAULT_MAJOR_SWAP=0
#	DEFAULT_MINOR_SWAP=0

# echo 'Root device is ('${DEFAULT_MAJOR_ROOT}, $DEFAULT_MINOR_ROOT')'
# echo 'Swap device is ('$DEFAULT_MAJOR_SWAP, $DEFAULT_MINOR_SWAP')'
########################################################

# Write bootsect (512 bytes, one sector) to stdout
[ ! -f "$bootsect" ] && echo "Error: No bootsect binary file there!" && exit -1
# dd if=$bootsect bs=32 of=$IMAGE skip=1 2>&1 >/dev/null  as86,ld86编译的可执行文件前32字节为文件头，之后才是指令码 skip=1略过1block（32字节）
dd if=$bootsect bs=512 count=1 of=$IMAGE 2>&1 >/dev/null

# Write setup(4 * 512bytes, four sectors) to stdout
[ ! -f "$setup" ] && echo "Error: No setup binary file there!" && exit -1
# dd if=$setup seek=16 bs=32 count=64 of=$IMAGE skip=1 2>&1 >/dev/null   as86,ld86编译的可执行文件前32字节为文件头，之后才是指令码 skip=1略过1block（32字节），写入字节数bs*count
dd if=$setup seek=1 bs=512 count=4 of=$IMAGE 2>&1 >/dev/null

# Write system(< SYS_SIZE) to stdout
[ ! -f "$system" ] && echo "Error: No system binary file there!" && exit -1

if [ `uname -s` = "Darwin" ]; then
    system_size=`wc -c $system |cut -d" " -f3`
elif [ `uname -s` = "Linux" ]; then
    system_size=`wc -c $system |cut -d" " -f1`
else
    echo "Error: No support os!"
    exit -1
fi

[ $system_size -gt $SYS_SIZE ] && echo "Note: the system binary is too big" && exit -1
dd if=$system seek=5 bs=512 count=$((2888-1-4)) of=$IMAGE 2>&1 >/dev/null

# Set "device" for the root image file
# echo -ne "\x$DEFAULT_MINOR_ROOT\x$DEFAULT_MAJOR_ROOT" | dd ibs=1 obs=1 count=2 seek=508 of=$IMAGE conv=notrunc  2>&1 >/dev/null 挪到setrootdev.sh
# echo -ne "\x$DEFAULT_MINOR_SWAP\x$DEFAULT_MAJOR_SWAP" | dd ibs=1 obs=1 count=2 seek=506 of=$IMAGE conv=notrunc  2>&1 >/dev/null 挪到setrootdev.sh

# dd bs=1024 if=root of=$IMAGE seek=256 skip=256

