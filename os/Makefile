# FlyOS - Makefile

ASM      = nasm
ASMFLAGS = -f bin

.PHONY: all run clean

all: flyos.img

mbr.bin: mbr.asm
	$(ASM) $(ASMFLAGS) mbr.asm -o mbr.bin

stage1.bin: stage1.asm
	$(ASM) $(ASMFLAGS) stage1.asm -o stage1.bin

flyos.img: mbr.bin stage1.bin
	cat mbr.bin stage1.bin > flyos.img

run: flyos.img
	@echo "Image size:"
	@stat -c %s flyos.img
	qemu-system-i386 -drive format=raw,file=flyos.img

clean:
	rm -f mbr.bin stage1.bin flyos.img
