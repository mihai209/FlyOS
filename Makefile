ASM = nasm
QEMU = qemu-system-i386

BOOT = BOOT.ASM
IMG  = flyos.img

all: $(IMG)

$(IMG): $(BOOT)
	$(ASM) -f bin $(BOOT) -o boot.bin
	dd if=/dev/zero of=$(IMG) bs=512 count=2880
	dd if=boot.bin of=$(IMG) bs=512 count=1 conv=notrunc

run: $(IMG)
	$(QEMU) -drive file=$(IMG),format=raw,index=0,media=disk

clean:
	rm -f *.bin *.img
