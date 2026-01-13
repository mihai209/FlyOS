# FlyOS - Generic Makefile

ASM      = nasm
ASMFLAGS = -f bin

# Bootloader stages in order. These are concatenated into the final image.
BOOT_STAGES_ASM = boot.asm stage1.asm
BOOT_STAGES_BIN = $(patsubst %.asm,%.bin,$(BOOT_STAGES_ASM))

# Other ASM files that are compiled but not part of the boot image
OTHER_ASM_SOURCES = $(filter-out $(BOOT_STAGES_ASM), $(wildcard *.asm))
OTHER_BIN_FILES = $(patsubst %.asm,%.bin,$(OTHER_ASM_SOURCES))

IMAGE = flyos.img

.PHONY: all run clean

# The default 'all' target builds the boot image and any other .bin files
all: $(IMAGE) $(OTHER_BIN_FILES)

# Generic rule to build .bin files from .asm files
%.bin: %.asm
	$(ASM) $(ASMFLAGS) $< -o $@

# Rule to build the final boot image by concatenating the boot stages
$(IMAGE): $(BOOT_STAGES_BIN)
	cat $(BOOT_STAGES_BIN) > $(IMAGE)

# Rule to run the OS in QEMU
run: $(IMAGE)
	@echo "Image size:"
	@stat -c %s $(IMAGE)
	qemu-system-i386 -drive format=raw,file=$(IMAGE)

# Rule to clean up all generated files
clean:
	rm -f $(BOOT_STAGES_BIN) $(OTHER_BIN_FILES) $(IMAGE)