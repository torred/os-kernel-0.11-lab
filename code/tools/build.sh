#!/bin/bash
# build.sh -- a shell version of build.c for the new bootsect.s & setup.s
# author: falcon <wuzhangjin@gmail.com>
# update: 2008-10-10

bootsect=$1
setup=$2
system=$3
IMAGE=$4

# Set the biggest sys_size
# Changes from 0x20000 to 0x30000 by tigercn to avoid oversized code.
SYS_SIZE=$((0x3000*16))
# SYS_SIZE=$((256*1024))  # 256*1024=0x40000

# Write bootsect (512 bytes, one sector) to stdout
[ ! -f "$bootsect" ] && echo "Error: No bootsect binary file there!" && exit -1
dd if=$bootsect bs=512 count=1 of=$IMAGE 2>&1 >/dev/null

# Write setup(4 * 512bytes, four sectors) to stdout
[ ! -f "$setup" ] && echo "Error: No setup binary file there!" && exit -1
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
