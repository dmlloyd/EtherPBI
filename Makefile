
BR_ASMFILES=$(sort $(wildcard bootrom/*.asm))
BR_OFILES=$(BR_ASMFILES:.asm=.obj)

FW_ASMFILES=$(sort $(wildcard firmware/*.asm))
FW_OFILES=$(FW_ASMFILES:.asm=.obj)

DEF_CFILES=$(sort $(wildcard deflate/*.c))
DEF_OFILES=$(DEF_CFILES:.c=.o)

all: bootrom.img firmware.cmp

bootrom.img: $(BR_OFILES) bootrom/linker.cfg
	@echo '     [ ld65 ] ' $< '->' $@
	@ld65 -vm -m bootrom/linker.map -C bootrom/linker.cfg --dbgfile bootrom/linker.dbg -o bootrom.img $(BR_OFILES)

firmware.fw: $(FW_OFILES) firmware/linker.cfg
	@echo '     [ ld65 ] ' $< '->' $@
	@ld65 -vm -m firmware/linker.map -C firmware/linker.cfg --dbgfile firmware/linker.dbg -o firmware.fw $(FW_OFILES)

firmware.cmp: firmware.fw deflate
	@echo '  [ deflate ] ' $< '->' $@
	@./deflater $< $@

deflater: $(DEF_OFILES)
	@echo '       [ cc ] ' $(DEF_OFILES) '->' $@
	@cc -lz -o deflater $(DEF_OFILES)

.c.o:
	@echo '       [ cc ] ' $< '->' $@
	@cc -c -o $@ $<

.asm.obj:
	@echo '     [ ca65 ] ' $< '->' $@
	@ca65 -Iinclude $< -l -o $@

.SUFFIXES: .asm .obj .c .o

clean:
	rm -rf *.img *.cmp $(BR_OFILES) $(FW_OFILES) $(DEF_OFILES) deflater */*.map */*.dbg
