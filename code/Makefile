#
# if you want the ram-disk device, define this to be the size in blocks.
#
RAMDISK      =  #-DRAMDISK=512
CLEAR_FILE   = images/Image images/system images/system.map images/kernel images/system.S images/system.tmp images/bootsect.map images/setup.map tmp_make
OBJDUMP_FILE = images/system.S
NM_FILE      = images/system.map

# -0: 使用16bit代码段　
# -a: 开启与GNU as，ld部分兼容性选项
#AS86	= $(QUIET_CC)as86 -0 -a

# -0: 产生具有16bit魔数的头结构
#LD86	= $(QUIET_LINK)ld86 -0

# This is a basic Makefile for setting the general configuration
include Makefile.make

# -e startup(新增): 指定入口
# -Ttext 0(新增): 使`startup`标号对应的地址为`0x0`
LDFLAGS	+= -Ttext 0 -e main
CFLAGS	+= $(RAMDISK)

#
# ROOT_DEV specifies the default root-device when making the image.
# This can be either FLOPPY, /dev/xxxx or empty, in which case the
# default of /dev/hd6 is used by 'build'.
#
# ROOT_DEV= #/dev/hd6
# SWAP_DEV= #/dev/hd2

ARCHIVES=kernel/kernel.o mm/mm.o fs/fs.o
DRIVERS =kernel/blk_drv/blk_drv.a kernel/chr_drv/chr_drv.a
MATH	=kernel/math/math.a
LIBS	=lib/lib.a

all:	Image

Image: boot/bootsect boot/setup tools/system
	@cp -f images/system images/system.tmp

# strip
# strip.symbol.debug strip strip

# strip <>
# -I --input-target=
# -O --output-target=
# -F --target=
# -p --preserve-dates
# -R --remove-section=
# -s --strip-all
# -g -S -d --strip-debug
#          --strip-unneeded
#          --only-keep-debug
# -N --strip-symbol=
# -K --keep-symbol=
# -w --wildcard
# -x --discard-all
# -X --discard-locals
# -v --verbose
# -V --version
# -h --help
# -o
	@$(STRIP) images/system.tmp

#.note.comment system.tmp kernel
# -I bfdname
# --input-target=bfdname
# Objcopy bfdname BFD
#  Objcopy BFD
# -O bfdname
# --output-target= bfdname
# bfdname BFD
# -R sectionname
# --remove-section= sectionname
#  sectionname
# -S
# --strip-all  strip
# -g
# --strip-debug
#--strip-undeeded
	@$(OBJCOPY) -O binary -R .note -R .comment images/system.tmp images/kernel
	@$(BUILD) boot/bootsect boot/setup images/kernel images/Image
	@sync

# 上面的修改就可以保证开启gcc调试后，System文件不变大，build也就不会失败了(build对system大小有
# 限制)。原先规则为下面两句
# tools/build boot/bootsect boot/setup tools/system $(ROOT_DEV) $(SWAP_DEV) > Image
# sync

# disk: Image
#	dd bs=8192 if=Image of=/dev/fd0
#	dd bs=8192 if=Image of=/dev/PS0

init/main.o: FORCE
	@make main.o -C init/

boot/head.o: boot/head.s
	@make head.o -C boot/

tools/system:	boot/head.o init/main.o \
		$(ARCHIVES) $(DRIVERS) $(MATH) $(LIBS)
	@$(LD) $(LDFLAGS) boot/head.o init/main.o \
	$(ARCHIVES) \
	$(DRIVERS) \
	$(MATH) \
	$(LIBS) \
	-o images/system

# nm   File
# -a debug-syms debugger-only symbols
# -B format=bsd MIPS nm
# -C demangle (demangle) C++
#	  no-demangle
# -D dynamic ( )
# -f format format format bsd sysv posix GNU nm bsd
# -g extern-only
# -n -v numeric-sort
# -p no-sort
# -P portability POSIX.2 -f posix
# -s print-armap
# -r reverse-sort ( )
#  size-sort
#  target=bfdname
# -u undefined-only ( )
#  defined-only:
# -l line-numbers
# -V version nm
#  help nm
	@$(NM) images/system | grep -v '\(compiled\)\|\(\.o$$\)\|\( [aU] \)\|\(\.\.ng$$\)\|\(LASH[RL]DI\)'| sort > images/system.map
	@$(OBJDUMP) -S images/system > images/system.S

kernel/math/math.a: FORCE
	@make -C kernel/math

kernel/blk_drv/blk_drv.a: FORCE
	@make -C kernel/blk_drv

kernel/chr_drv/chr_drv.a: FORCE
	@make -C kernel/chr_drv

kernel/kernel.o: FORCE
	@make -C kernel

mm/mm.o: FORCE
	@make -C mm

fs/fs.o: FORCE
	@make -C fs

lib/lib.a: FORCE
	@make -C lib

boot/setup: boot/setup.s FORCE
	@make setup -C boot

boot/bootsect: boot/bootsect.s FORCE
	@make bootsect -C boot

# tmp.s:	boot/bootsect.s tools/system
#

# 计算system大小，并在bootsect.s中定义其大小
# ifeq ($(OS), Linux)
#	@(echo -n "SYSSIZE = (";ls -l tools/system | grep system \
#	| cut -c25-31 | tr '\012' ' '; echo "+ 15 ) / 16") > tmp.s
#	@cat boot/bootsect.s >> tmp.s
# else ifeq ($(OS), Darwin)
#	@(echo -n "SYSSIZE = (";ls -l tools/system | grep system | cut -c28-33 | tr '\012' ' '; echo "+ 15 ) / 16") > tmp.s
#	@cat boot/bootsect.s >> tmp.s
# else
#	exit -1;
# endif

clean:
	@make clean -C rootfs
	@$(RM) -f $(CLEAR_FILE)
	@for i in init mm fs kernel lib boot; do make clean -C $$i; done

#info:
#	@make clean
#	@script -q -c "make all"
#	@cat typescript | col -bp | grep -E "warning|Error" > info
#	@cat info
#backup: clean
#	@(cd .. ; tar cf - linux | compress16 - > backup.Z)
#	@sync

dep:
	for i in init fs kernel mm; do make dep -C $$i; done

FORCE: ;

# Test on emulators with different prebuilt rootfs
include Makefile.emulators

help:
	@echo "------------------Linux 0.11 Lab (http://tinylab.org/linux-0.11-lab)------------------"
	@echo ""
	@echo "     :: Compile ::"
	@echo ""
	@echo "     make --generate a kernel floppy Image with a fs on hda1"
	@echo "     make clean -- clean the object files"
	@echo ""
	@echo "     :: Test ::"
	@echo ""
	@echo "     make start -- start the kernel in vm (qemu/bochs)"
	@echo "     make start-fd -- start the kernel with fs in floppy"
	@echo "     make start-hd -- start the kernel with fs in hard disk"
	@echo ""
	@echo "     :: Debug ::"
	@echo ""
	@echo "     make debug -- debug the kernel in qemu/bochs & gdb at port 1234"
	@echo "     make debug-fd -- debug the kernel with fs in floppy"
	@echo "     make debug-hd -- debug the kernel with fs in hard disk"
	@echo ""
	@echo "     make switch -- switch the emulator: qemu and bochs"
	@echo ""
	@echo "     :: More ::"
	@echo ""
	@echo "     >>> README.md <<<"
	@echo ""
	@echo "     ~ Enjoy It ~"
	@echo ""
	@echo "-------------------Linux 0.11 Lab (http://tinylab.org/linux-0.11-lab)-------------------"


