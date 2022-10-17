
include ../Makefile.make

OBJS	= memory.o page.o
CLEAR_FILE = $(OBJS) mm.o tmp_make

LDFLAGS += -r
CFLAGS	+= -finline-functions -nostdinc -I../include
CPP	+= -E -I../include
DEP	+= -E -I../include

.c.o:
	@$(CC) $(CFLAGS) \
	-c -o $*.o $<
.s.o:
	@$(AS) -o $*.o $<
.c.s:
	@$(CC) $(CFLAGS) \
	-S -o $*.s $<

all: mm.o

mm.o: $(OBJS)
	@$(LD) $(LDFLAGS) -o mm.o $(OBJS)

clean:
	@$(RM) -f $(CLEAR_FILE)
#	@for i in *.c;do rm -f `basename $$i .c`.s;done  gcc.s

dep:
	@$(QUIET_DEP)
	@sed '/\#\#\# Dependencies/q' < Makefile > tmp_make
	@(for i in *.c;do $(DEP) -M $$i;done) >> tmp_make
	@cp tmp_make Makefile

### Dependencies:
memory.o: memory.c ../include/signal.h ../include/sys/types.h \
 ../include/asm/system.h ../include/linux/sched.h ../include/linux/head.h \
 ../include/linux/fs.h ../include/linux/mm.h ../include/linux/kernel.h
