#
# Makefile for the FREAX-kernel character device drivers.
#
# Note! Dependencies are done automagically by 'make dep', which also
# removes any old dependencies. DON'T put your own dependencies here
# unless it's something special (ie not a .c file).
#

include ../../Makefile.make

OBJS  = tty_io.o console.o keyboard.o serial.o rs_io.o \
	tty_ioctl.o
CLEAR_FILE = $(OBJS) keyboard.s chr_drv.a tmp_make

CFLAGS	+= -finline-functions -nostdinc -I../../include
CPP	+= -E -I../../include
DEP	+= -E -I../../include

.c.s:
	@$(CC) $(CFLAGS) \
	-S -o $*.s $<
.s.o:
	@$(AS) -o $*.o $<
.c.o:
	@$(CC) $(CFLAGS) \
	-c -o $*.o $<

chr_drv.a: $(OBJS)
	@$(AR) rcs chr_drv.a $(OBJS)
	@sync

keyboard.s: kb.S
	@$(CPP) -traditional kb.S -o keyboard.s

clean:
	@$(RM) -f $(CLEAR_FILE)

dep:
	@$(QUIET_DEP)
	@sed '/\#\#\# Dependencies/q' < Makefile > tmp_make
	@(for i in *.c;do $(DEP) -M $$i;done) >> tmp_make
	@cp tmp_make Makefile

### Dependencies:
console.o: console.c ../../include/linux/sched.h \
 ../../include/linux/head.h ../../include/linux/fs.h \
 ../../include/sys/types.h ../../include/linux/mm.h \
 ../../include/signal.h ../../include/linux/tty.h ../../include/termios.h \
 ../../include/asm/io.h ../../include/asm/system.h
serial.o: serial.c ../../include/linux/tty.h ../../include/termios.h \
 ../../include/linux/sched.h ../../include/linux/head.h \
 ../../include/linux/fs.h ../../include/sys/types.h \
 ../../include/linux/mm.h ../../include/signal.h \
 ../../include/asm/system.h ../../include/asm/io.h
tty_io.o: tty_io.c ../../include/ctype.h ../../include/errno.h \
 ../../include/signal.h ../../include/sys/types.h \
 ../../include/linux/sched.h ../../include/linux/head.h \
 ../../include/linux/fs.h ../../include/linux/mm.h \
 ../../include/linux/tty.h ../../include/termios.h \
 ../../include/asm/segment.h ../../include/asm/system.h
tty_ioctl.o: tty_ioctl.c ../../include/errno.h ../../include/termios.h \
 ../../include/linux/sched.h ../../include/linux/head.h \
 ../../include/linux/fs.h ../../include/sys/types.h \
 ../../include/linux/mm.h ../../include/signal.h \
 ../../include/linux/kernel.h ../../include/linux/tty.h \
 ../../include/asm/io.h ../../include/asm/segment.h \
 ../../include/asm/system.h
