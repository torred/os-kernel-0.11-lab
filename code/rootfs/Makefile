include ../Makefile.make

CLEAR_FILE = $(HDA_IMG) $(FLP_IMG) $(RAM_IMG)

HDA_IMG_FLAG := $(shell find ./ -name $(HDA_IMG))
FLP_IMG_FLAG := $(shell find ./ -name $(FLP_IMG))
RAM_IMG_FLAG := $(shell find ./ -name $(RAM_IMG))

hda: $(HDA_IMG).xz
ifeq ($(HDA_IMG_FLAG),)
	@$(TAR) Jvxf $<
endif

flp: $(FLP_IMG).xz
ifeq ($(FLP_IMG_FLAG),)
	@$(TAR) Jvxf $<
endif

ramfs: $(RAM_IMG).xz
ifeq ($(RAM_IMG_FLAG),)
	@$(TAR) Jvxf $<
endif

clean:
	@$(RM) -f $(CLEAR_FILE)