#
# Makefile for the FREAX-kernel character device drivers.
#
# Note! Dependencies are done automagically by 'make dep', which also
# removes any old dependencies. DON'T put your own dependencies here
# unless it's something special (ie not a .c file).
#

include ../../Makefile.make

OBJS  = math_emulate.o
CLEAR_FILE = $(OBJS) math.a tmp_make
	
CFLAGS	+= -finline-functions -nostdinc -I../../include
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

math.a: $(OBJS)
	@$(AR) rcs math.a $(OBJS)
	@sync

clean:
	@$(RM) -f $(CLEAR_FILE)

dep:
	@$(QUIET_DEP)
	@sed '/\#\#\# Dependencies/q' < Makefile > tmp_make
	@(for i in *.c;do $(DEP) -M $$i;done) >> tmp_make
	@cp tmp_make Makefile

### Dependencies:
math_emulate.o: math_emulate.c ../../include/signal.h \
 ../../include/sys/types.h ../../include/linux/sched.h \
 ../../include/linux/head.h ../../include/linux/fs.h \
 ../../include/linux/mm.h ../../include/linux/kernel.h \
 ../../include/asm/segment.h
