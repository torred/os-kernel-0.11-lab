OS := $(shell uname)

# >>>> 实验环境设置
# ---------------------------------------------------------
export OS_LAB_ROOT=$(HOME)/Workspace/kernel/os-linux-0.11-lab
export OS_LAB_ENV=$(OS_LAB_ROOT)/env
export OS_LAB_TOOLS=$(OS_LAB_ROOT)/tools

# >>>> 设置编译连接工具环境
# ---------------------------------------------------------
KERNEL_INCLUDE = ./include
BUILD = ./tools/build.sh

ifeq ($(OS), Linux)
	TARGET=
else ifeq ($(OS), Darwin)
	TARGET=x86_64-elf-
else
	exit -1;
endif

AS	= $(TARGET)as --32
LD	= $(TARGET)ld
AR	= $(TARGET)ar
STRIP = $(TARGET)strip
OBJCOPY = $(TARGET)objcopy

CC	= $(TARGET)gcc
CPP	= $(TARGET)cpp -nostdinc

#LDFLAGS = -m elf_i386 -x
LDFLAGS = -m elf_i386

# we should use -fno-stack-protector with gcc 4.3
ifeq ($(OS), Linux)
	CFLAGS  = -g -m32 -fno-builtin -fno-stack-protector -fomit-frame-pointer -fstrength-reduce -w #-Wall
else ifeq ($(OS), Darwin)
	#CFLAGS  = -gdwarf-2 -g3 -m32 -fno-builtin -fno-stack-protector -fomit-frame-pointer -fstrength-reduce -w #-Wall
	CFLAGS  = -g -O0 -m32 -fno-builtin -fno-stack-protector -fomit-frame-pointer -fstrength-reduce -w #-Wall
else
	exit -1;
endif

# ---------------------------------------------------------

# >>>> Qemu配置，可根据实际安装环境进行定制
# ---------------------------------------------------------
ifeq ($(OS), Linux)
	QEMU_HOME=/usr/local/Cellar/qemu/7.1.0/bin
	QEMU=$(QEMU_HOME)/qemu-system-i386
else ifeq ($(OS), Darwin)
	QEMU_HOME=/usr/local/Cellar/qemu/7.1.0/bin
	QEMU=$(QEMU_HOME)/qemu-system-i386
else
	exit -1;
endif


# ---------------------------------------------------------

# >>>> Bochs配置，可根据实际安装环境进行定制
# ---------------------------------------------------------
ifeq ($(OS), Linux)
	BOCHS_HOME=/home/todd/.local/bochs-i386
	BOCHS_DISP_LIB=x
	BOCHS_KEYBOARD=x11-pc-de.map
else ifeq ($(OS), Darwin)
	BOCHS_HOME=/usr/local/Cellar/bochs/2.6.11-x86
	BOCHS_DISP_LIB=sdl2
	BOCHS_KEYBOARD=sdl2-pc-de.map
else
	exit -1;
endif

export BOCHS_DISP_LIB BOCHS_KEYBOARD
export BXSHARE=$(BOCHS_HOME)/share/bochs
BOCHS=$(BOCHS_HOME)/bin/bochs
BOCHS_RC=$(OS_LAB_ENV)/bochs
# ---------------------------------------------------------

# >>>> VM configuration
# ---------------------------------------------------------
VM_CFG = tools/vm.cfg
# ---------------------------------------------------------

# ---------------------------------------------------------

# >>>> Tool for specify root device
# ---------------------------------------------------------
SETROOTDEV = tools/setrootdev.sh
# ---------------------------------------------------------

# >>>> Specify the Rootfs Image file
# ---------------------------------------------------------
HDA_IMG = hdc-0.11.img
FLP_IMG = rootimage-0.11
RAM_IMG = rootram.img
# ---------------------------------------------------------