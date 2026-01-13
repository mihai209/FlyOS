AS = nasm
CC = i686-elf-gcc
LD = i686-elf-ld

CFLAGS = -ffreestanding -O2 -Wall -Wextra -fno-pic -fno-stack-protector
LDFLAGS = -T kernel/linker.ld -nostdlib

ISO = flyos.iso

all: $(ISO)

dirs:
	mkdir -p iso/boot

boot.bin: dirs
	$(AS) -f bin kernel/boot/boot.asm -o boot.bin

kernel.bin:
	$(AS) -f elf32 kernel/boot/main.asm -o kboot.o
	$(CC) $(CFLAGS) -c kernel/lib/vga.c -o vga.o
	$(CC) $(CFLAGS) -c kernel/main.c -o kmain.o
	$(LD) $(LDFLAGS) kboot.o vga.o kmain.o -o kernel.bin

$(ISO): boot.bin kernel.bin
	cp boot.bin iso/boot/boot.bin
	cp kernel.bin iso/boot/kernel.bin
	mkisofs -R -b boot/boot.bin -no-emul-boot -boot-load-size 4 -o $(ISO) iso

run: $(ISO)
	qemu-system-i386 -cdrom $(ISO)

clean:
	rm -f *.o *.bin $(ISO)
	rm -rf iso
