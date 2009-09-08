
BR_ASMFILES=$(sort $(wildcard bootrom/*.asm))
BR_OFILES=$(BR_ASMFILES:.asm=.obj)

FW_ASMFILES=$(sort $(wildcard firmware/*.asm))
FW_OFILES=$(FW_ASMFILES:.asm=.obj)

DEF_CFILES=$(sort $(wildcard deflater/*.c))
DEF_OFILES=$(DEF_CFILES:.c=.o)

all: bootrom.img firmware.cmp

bootrom.img: $(BR_OFILES) bootrom/linker.cfg
	@echo '     [ ld65 ] ' $< '->' $@
	@ld65 -vm -m bootrom/linker.map -C bootrom/linker.cfg --dbgfile bootrom/linker.dbg -o bootrom.img $(BR_OFILES)

firmware.img: $(FW_OFILES) firmware/linker.cfg
	@echo '     [ ld65 ] ' $< '->' $@
	@ld65 -vm -m firmware/linker.map -C firmware/linker.cfg --dbgfile firmware/linker.dbg -o firmware.img $(BR_OFILES)

firmware.cmp: firmware.img deflate
	@echo '  [ deflate ] ' $< '->' $@
	@deflate $< > $@

deflate: $(DEF_OFILES)

.c.o:
	@echo '       [ cc ] ' $< '->' $@
	@cc -c -o $@ $<

.asm.obj:
	@echo '     [ ca65 ] ' $< '->' $@

.SUFFIXES: .asm .obj .c .o

clean:
	rm -rf *.img *.cmp $(BR_OFILES) $(FW_OFILES) $(DEF_OFILES) deflate */*.map */*.dbg
