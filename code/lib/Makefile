#
# Makefile for some libs needed in the kernel.
#
# Note! Dependencies are done automagically by 'make dep', which also
# removes any old dependencies. DON'T put your own dependencies here
# unless it's something special (ie not a .c file).
#

include ../Makefile.make

OBJS  = ctype.o _exit.o open.o close.o errno.o write.o dup.o setsid.o \
	execve.o wait.o string.o malloc.o
CLEAR_FILE = $(OBJS) lib.a tmp_make

CFLAGS	+= -finline-functions -nostdinc -I../include
CPP	+= -E -I../include
DEP	+= -I../include

.c.s:
	@$(CC) $(CFLAGS) \
	-S -o $*.s $<
.s.o:
	@$(AS) -c -o $*.o $<
.c.o:
	@$(CC) $(CFLAGS) \
	-c -o $*.o $<

lib.a: $(OBJS)
	@$(AR) rcs lib.a $(OBJS)
	@sync

clean:
#	@for i in *.c;do rm -f `basename $$i.c`.s;done
	@$(RM) -f $(CLEAR_FILE)

dep:
	@$(QUIET_DEP)
	@sed '/\#\#\# Dependencies/q' < Makefile > tmp_make
	@(for i in *.c;do $(DEP) -M $$i;done) >> tmp_make
	@cp tmp_make Makefile

### Dependencies:
close.o: close.c ../include/unistd.h ../include/sys/stat.h \
 ../include/sys/types.h ../include/sys/times.h ../include/sys/utsname.h \
 ../include/utime.h
ctype.o: ctype.c ../include/ctype.h
dup.o: dup.c ../include/unistd.h ../include/sys/stat.h \
 ../include/sys/types.h ../include/sys/times.h ../include/sys/utsname.h \
 ../include/utime.h
errno.o: errno.c
execve.o: execve.c ../include/unistd.h ../include/sys/stat.h \
 ../include/sys/types.h ../include/sys/times.h ../include/sys/utsname.h \
 ../include/utime.h
_exit.o: _exit.c ../include/unistd.h ../include/sys/stat.h \
 ../include/sys/types.h ../include/sys/times.h ../include/sys/utsname.h \
 ../include/utime.h
malloc.o: malloc.c ../include/linux/kernel.h ../include/linux/mm.h \
 ../include/asm/system.h
open.o: open.c ../include/unistd.h ../include/sys/stat.h \
 ../include/sys/types.h ../include/sys/times.h ../include/sys/utsname.h \
 ../include/utime.h ../include/stdarg.h
setsid.o: setsid.c ../include/unistd.h ../include/sys/stat.h \
 ../include/sys/types.h ../include/sys/times.h ../include/sys/utsname.h \
 ../include/utime.h
string.o: string.c ../include/string.h
wait.o: wait.c ../include/unistd.h ../include/sys/stat.h \
 ../include/sys/types.h ../include/sys/times.h ../include/sys/utsname.h \
 ../include/utime.h ../include/sys/wait.h
write.o: write.c ../include/unistd.h ../include/sys/stat.h \
 ../include/sys/types.h ../include/sys/times.h ../include/sys/utsname.h \
 ../include/utime.h
