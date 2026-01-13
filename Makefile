ASM = nasm

all: flyos.img

boot.bin: BOOT.ASM
	$(ASM) -f bin BOOT.ASM -o boot.bin

loader.bin: LOADER.ASM
	$(ASM) -f bin LOADER.ASM -o loader.bin

flyos.img: boot.bin loader.bin
	dd if=/dev/zero of=flyos.img bs=512 count=32768
	dd if=boot.bin of=flyos.img conv=notrunc
	dd if=loader.bin of=flyos.img bs=512 seek=1 conv=notrunc

run:
	qemu-system-i386 -drive file=flyos.img,format=raw,index=0,media=disk

clean:
	rm -f *.bin *.img
