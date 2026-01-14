ARCH        := x86_64
TARGET      := BOOTX64.EFI
BUILD_DIR   := ../../build/boot
ISO_DIR     := ../../iso/EFI/BOOT

CC          := clang
LD          := ld.lld

CFLAGS := \
	--target=$(ARCH)-elf \
	-ffreestanding \
	-fno-stack-protector \
	-fno-pic -fno-pie \
	-mno-red-zone \
	-O2 -Wall -Wextra \
	-Iloader

LDFLAGS := \
	-nostdlib \
	-Wl,-T,linker.ld \
	-Wl,--subsystem,efi_application \
	-Wl,--entry,efi_main

SRCS := \
	loader/main.c

OBJS := $(SRCS:%.c=$(BUILD_DIR)/%.o)

$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/$(TARGET): $(OBJS)
	$(CC) -fuse-ld=lld $(LDFLAGS) $^ -o $@
	@mkdir -p $(ISO_DIR)
	cp $@ $(ISO_DIR)/$(TARGET)

all: $(BUILD_DIR)/$(TARGET)

clean:
	rm -rf $(BUILD_DIR)
