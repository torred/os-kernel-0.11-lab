#
# Makefile for the FREAX-kernel block device drivers.
#
# Note! Dependencies are done automagically by 'make dep', which also
# removes any old dependencies. DON'T put your own dependencies here
# unless it's something special (ie not a .c file).
#

OBJS  = ll_rw_blk.o floppy.o hd.o ramdisk.o
CLEAR_FILE = $(OBJS) blk_drv.a tmp_make
include ../../Makefile.make

CFLAGS	+= -finline-functions  -nostdinc -I../../include
CPP	+= -E -I../../include
DEP	+= -E -I../../include

.c.s:
	@$(CC) $(CFLAGS) \
	-S -o $*.s $<
.s.o:
	@$(AS) -c -o $*.o $<
.c.o:
	@$(CC) $(CFLAGS) \
	-c -o $*.o $<

blk_drv.a: $(OBJS)
	@$(AR) rcs blk_drv.a $(OBJS)
	@sync

clean:
	@$(RM) -f $(CLEAR_FILE)

dep:
	@$(QUIET_DEP)
	@sed '/\#\#\# Dependencies/q' < Makefile > tmp_make
	@(for i in *.c;do $(DEP) -M $$i;done) >> tmp_make
	@cp tmp_make Makefile

### Dependencies:
floppy.o: floppy.c ../../include/linux/sched.h ../../include/linux/head.h \
 ../../include/linux/fs.h ../../include/sys/types.h \
 ../../include/linux/mm.h ../../include/signal.h \
 ../../include/linux/kernel.h ../../include/linux/fdreg.h \
 ../../include/asm/system.h ../../include/asm/io.h \
 ../../include/asm/segment.h blk.h
hd.o: hd.c ../../include/linux/config.h ../../include/linux/sched.h \
 ../../include/linux/head.h ../../include/linux/fs.h \
 ../../include/sys/types.h ../../include/linux/mm.h \
 ../../include/signal.h ../../include/linux/kernel.h \
 ../../include/linux/hdreg.h ../../include/asm/system.h \
 ../../include/asm/io.h ../../include/asm/segment.h blk.h
ll_rw_blk.o: ll_rw_blk.c ../../include/errno.h \
 ../../include/linux/sched.h ../../include/linux/head.h \
 ../../include/linux/fs.h ../../include/sys/types.h \
 ../../include/linux/mm.h ../../include/signal.h \
 ../../include/linux/kernel.h ../../include/asm/system.h blk.h
ramdisk.o: ramdisk.c ../../include/string.h ../../include/linux/config.h \
 ../../include/linux/sched.h ../../include/linux/head.h \
 ../../include/linux/fs.h ../../include/sys/types.h \
 ../../include/linux/mm.h ../../include/signal.h \
 ../../include/linux/kernel.h ../../include/asm/system.h \
 ../../include/asm/segment.h ../../include/asm/memory.h blk.h
