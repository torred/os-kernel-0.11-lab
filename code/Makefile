#
# if you want the ram-disk device, define this to be the
# size in blocks.
#
RAMDISK =  #-DRAMDISK=512

# This is a basic Makefile for setting the general configuration
include Makefile.make

LDFLAGS	+= -Ttext 0 -e startup_32
CFLAGS	+= $(RAMDISK) -Iinclude
CPP	+= -Iinclude

ARCHIVES=kernel/kernel.o mm/mm.o fs/fs.o
DRIVERS =kernel/blk_drv/blk_drv.a kernel/chr_drv/chr_drv.a
MATH	=kernel/math/math.a
LIBS	=lib/lib.a

.c.s:
	@$(CC) $(CFLAGS) -S -o $*.s $<
.s.o:
	@$(AS)  -o $*.o $<
.c.o:
	@$(CC) $(CFLAGS) -c -o $*.o $<

all:	Image	

Image: boot/bootsect boot/setup tools/system FORCE
	@cp -f images/system images/system.tmp
	@$(STRIP) images/system.tmp
	@$(OBJCOPY) -O binary -R .note -R .comment images/system.tmp images/kernel
	@$(BUILD) boot/bootsect boot/setup images/kernel images/Image
	@rm -f images/system.tmp images/kernel
	@sync

# disk: Image
#	@dd bs=8192 if=Image of=/dev/fd0

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
	@nm images/system | grep -v '\(compiled\)\|\(\.o$$\)\|\( [aU] \)\|\(\.\.ng$$\)\|\(LASH[RL]DI\)'| sort > images/system.map

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
	@rm -f images/Image tmp_make boot/bootsect boot/setup
	@rm -f init/*.o images/system images/system.map boot/*.o typescript* info
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
	@sed '/\#\#\# Dependencies/q' < Makefile > tmp_make
	@cp tmp_make Makefile
	@for i in init fs kernel mm; do make dep -C $$i; done

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


