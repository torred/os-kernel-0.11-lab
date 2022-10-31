#!/bin/bash
# setswapdev.sh -- set the swap device in Image file
# author: torred <torred@163.com>
# update: 2022-10-18

#
# swap_dev: 0304

IMAGE=$1
swap_dev=$4

# by default, using the integrated swap
# set the default "device" file for swap
# DEFAULT_MAJOR_SWAP=0
# DEFAULT_MINOR_SWAP=0

if [ -z "$swap_dev" ]; then
	DEFAULT_MAJOR_SWAP=3
	DEFAULT_MINOR_SWAP=4
else
	DEFAULT_MAJOR_SWAP=${swap_dev:0:2}
	DEFAULT_MINOR_SWAP=${swap_dev:2:3}
fi

echo 'Swap device is ('$DEFAULT_MAJOR_SWAP, $DEFAULT_MINOR_SWAP')'

# Set "swap" for the root image file
echo -ne "\x$DEFAULT_MINOR_SWAP\x$DEFAULT_MAJOR_SWAP" | dd ibs=1 obs=1 count=2 seek=506 of=$IMAGE conv=notrunc  2>&1 >/dev/null