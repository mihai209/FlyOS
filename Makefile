# =========================
# FlyOS – El Torito ISO
# =========================

ARCH      := i386
CC        := gcc
LD        := ld
AS        := nasm
OBJCOPY   := objcopy

CFLAGS    := -m32 -ffreestanding -fno-pic -fno-stack-protector \
             -fno-builtin -nostdlib -nostartfiles -nodefaultlibs \
             -nostdinc -Ikernel/lib \
             -Wall -Wextra -O2

LDFLAGS   := -m elf_i386 -nostdlib

ISO       := flyos.iso
BOOTBIN   := boot.bin
KERNELELF := kernel.elf


# =========================
# Obiecte
# =========================

ASM_OBJS := boot/eltorito.o
C_OBJS   := kernel/main.o kernel/lib/stdio.o

OBJS := $(ASM_OBJS) $(C_OBJS)

# =========================
# Target-uri
# =========================

all: $(ISO)

clean:
	rm -f $(OBJS) $(KERNELELF) $(BOOTBIN) $(ISO)
	rm -rf iso

run: $(ISO)
	qemu-system-i386 -cdrom $(ISO) -boot d -no-reboot

debug: $(ISO)
	clear
	qemu-system-i386 -cdrom $(ISO) -boot d -no-reboot -d int

# =========================
# ASM
# =========================

boot/eltorito.o: boot/eltorito.asm
	$(AS) -f elf32 $< -o $@

# =========================
# C
# =========================

kernel/main.o: kernel/main.c
	$(CC) $(CFLAGS) -c $< -o $@

kernel/lib/stdio.o: kernel/lib/stdio.c
	$(CC) $(CFLAGS) -c $< -o $@

# =========================
# Link
# =========================

$(KERNELELF): $(OBJS) kernel/linker.ld
	$(LD) $(LDFLAGS) -T kernel/linker.ld $(OBJS) -o $@

# =========================
# Binary El Torito
# =========================

$(BOOTBIN): $(KERNELELF)
	$(OBJCOPY) -O binary $(KERNELELF) $@
	truncate -s 2048 $@

# =========================
# ISO
# =========================

$(ISO): $(BOOTBIN)
	mkdir -p iso
	cp $(BOOTBIN) iso/boot.bin
	mkisofs -quiet \
		-b boot.bin \
		-no-emul-boot \
		-boot-load-size 4 \
		-boot-info-table \
		-o $(ISO) iso
	rm -rf iso
