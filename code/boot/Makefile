include ../Makefile.make

CLEAR_FILE = bootsect bootsect.o setup setup.o head.o bootsect.pc setup.pc tmp_make

LDFLAGS	+= -Ttext 0
CPP	    += -I../include
DEP	    += -I../include

all: bootsect setup

bootsect: bootsect.pc
	@$(AS) -o bootsect.o bootsect.pc
	@$(LD) $(LDFLAGS) -o bootsect bootsect.o
	@cp -f bootsect bootsect.sym
	@nm bootsect.sym | grep -v '\(compiled\)\|\(\.o$$\)\|\( [aU] \)\|\(\.\.ng$$\)\|\(LASH[RL]DI\)'| sort > ../images/bootsect.map
	@rm -f bootsect.sym
	@$(OBJCOPY) -R .pdr -R .comment -R.note -S -O binary bootsect

bootsect.pc: bootsect.s
	@$(CPP) -o bootsect.pc bootsect.s

setup: setup.pc
	@$(AS) -o setup.o setup.pc
	@$(LD) $(LDFLAGS) -o setup setup.o
	@cp -f setup setup.sym
	@nm setup.sym | grep -v '\(compiled\)\|\(\.o$$\)\|\( [aU] \)\|\(\.\.ng$$\)\|\(LASH[RL]DI\)'| sort > ../images/setup.map
	@rm -f setup.sym
	@$(OBJCOPY) -R .pdr -R .comment -R.note -S -O binary setup

setup.pc: setup.s
	@$(CPP) -o setup.pc setup.s

head.o: head.s
	@$(AS) -o head.o head.s

clean:
	@$(RM) -f $(CLEAR_FILE)

dep:
	@$(QUIET_DEP)
	@sed '/\#\#\# Dependencies/q' < Makefile > tmp_make
	@(for i in *.s;do $(DEP) -M $$i;done) >> tmp_make
	@cp tmp_make Makefile

### Dependencies:
bootsect.o: bootsect.s ../include/linux/config.h
head.o: head.s
setup.o: setup.s ../include/linux/config.h
