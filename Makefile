.PHONY: all clean boot kernel iso run-qemu

all: boot iso

boot:
	$(MAKE) -C boot/uefi

kernel:
	$(MAKE) -C kernel

iso: boot
	tools/mkiso.sh

run-qemu: iso
	tools/run-qemu.sh

clean:
	$(MAKE) -C boot/uefi clean
	$(MAKE) -C kernel clean
	rm -rf build/iso
