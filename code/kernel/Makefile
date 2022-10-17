#
# Makefile for the FREAX-kernel.
#
# Note! Dependencies are done automagically by 'make dep', which also
# removes any old dependencies. DON'T put your own dependencies here
# unless it's something special (ie not a .c file).
#

include ../Makefile.make

OBJS  = sched.o system_call.o traps.o asm.o fork.o \
	panic.o printk.o vsprintf.o sys.o exit.o \
	signal.o mktime.o who.o
CLEAR_FILE = $(OBJS) kernel.o tmp_make

LDFLAGS += -r

# NOTE!: do not try to add -On to CFLAGS with gcc4.x, which will optimize the
# memcpy function a lot to let the kernel not work, for fixing this problem,
# please refer to glibc and rewrite the memcpy in include/string.h, or just not
# use any -On options with gcc 4.x when compiling it. in fact, we only can not
# use -On with gcc4.x to compile fork.c, but after that you need to isolate the
# compling procedure of it, it's not good too. for playing with linux-0.11, we
# just have fun, have no much concerning about the performance.

CFLAGS  += -O -finline-functions -nostdinc -I../include

CPP     += -E -I../include
DEP	+= -E -I../include

.c.s:
	@$(CC) $(CFLAGS) \
	-S -o $*.s $<
.s.o:
	@$(AS) -o $*.o $<
.c.o:
	@$(CC) $(CFLAGS) \
	-c -o $*.o $<

kernel.o: $(OBJS)
	@$(LD) $(LDFLAGS) -o kernel.o $(OBJS)
	@sync

clean:
	@$(RM) -f $(CLEAR_FILE)
	@for i in chr_drv blk_drv math; do make clean -C $$i; done

dep:
	@$(QUIET_DEP)
	@sed '/\#\#\# Dependencies/q' < Makefile > tmp_make
	@(for i in *.c;do $(DEP) -M $$i;done) >> tmp_make
	@cp tmp_make Makefile
	@for i in chr_drv blk_drv math; do make dep -C $$i; done

### Dependencies:
exit.o: exit.c ../include/errno.h ../include/signal.h \
 ../include/sys/types.h ../include/sys/wait.h ../include/linux/sched.h \
 ../include/linux/head.h ../include/linux/fs.h ../include/linux/mm.h \
 ../include/linux/kernel.h ../include/linux/tty.h ../include/termios.h \
 ../include/asm/segment.h
fork.o: fork.c ../include/string.h ../include/errno.h \
 ../include/linux/sched.h ../include/linux/head.h ../include/linux/fs.h \
 ../include/sys/types.h ../include/linux/mm.h ../include/signal.h \
 ../include/linux/kernel.h ../include/asm/segment.h \
 ../include/asm/system.h
mktime.o: mktime.c ../include/time.h
panic.o: panic.c ../include/linux/kernel.h ../include/linux/sched.h \
 ../include/linux/head.h ../include/linux/fs.h ../include/sys/types.h \
 ../include/linux/mm.h ../include/signal.h
printk.o: printk.c ../include/stdarg.h ../include/stddef.h \
 ../include/linux/kernel.h
sched.o: sched.c ../include/linux/sched.h ../include/linux/head.h \
 ../include/linux/fs.h ../include/sys/types.h ../include/linux/mm.h \
 ../include/signal.h ../include/linux/kernel.h ../include/linux/sys.h \
 ../include/linux/fdreg.h ../include/asm/system.h ../include/asm/io.h \
 ../include/asm/segment.h
signal.o: signal.c ../include/linux/sched.h ../include/linux/head.h \
 ../include/linux/fs.h ../include/sys/types.h ../include/linux/mm.h \
 ../include/signal.h ../include/linux/kernel.h ../include/asm/segment.h
sys.o: sys.c ../include/errno.h ../include/linux/sched.h \
 ../include/linux/head.h ../include/linux/fs.h ../include/sys/types.h \
 ../include/linux/mm.h ../include/signal.h ../include/linux/tty.h \
 ../include/termios.h ../include/linux/kernel.h ../include/asm/segment.h \
 ../include/sys/times.h ../include/sys/utsname.h
traps.o: traps.c ../include/string.h ../include/linux/head.h \
 ../include/linux/sched.h ../include/linux/fs.h ../include/sys/types.h \
 ../include/linux/mm.h ../include/signal.h ../include/linux/kernel.h \
 ../include/asm/system.h ../include/asm/segment.h ../include/asm/io.h
vsprintf.o: vsprintf.c ../include/stdarg.h ../include/string.h
who.o: who.c ../include/string.h ../include/errno.h \
 ../include/asm/segment.h
