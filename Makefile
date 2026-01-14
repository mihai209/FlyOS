# =========================
# Toolchain (host GCC)
# =========================
CC := gcc
LD := gcc
OBJCOPY := objcopy

# =========================
# Flags
# =========================
CFLAGS := -std=gnu11 \
          -ffreestanding \
          -fno-stack-protector \
          -fno-pic -fno-pie \
          -mno-red-zone \
          -Wall -Wextra \
          -O2

LDFLAGS := -T linker.ld \
           -nostdlib \
           -no-pie

# =========================
# Paths
# =========================
BUILD := build

# =========================
# Objects (EXPLICIT)
# =========================
OBJS := \
	$(BUILD)/start.o \
	$(BUILD)/gdt.o \
	$(BUILD)/gdt_load.o \
	$(BUILD)/tss.o \
	$(BUILD)/kernel.o


# =========================
# Default target
# =========================
all: kernel.elf

# =========================
# Link
# =========================
kernel.elf: $(OBJS)
	$(LD) $(LDFLAGS) $^ -o $@

# =========================
# Build rules
# =========================
$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/start.o: kernel/start.S | $(BUILD)
	$(CC) -c $< -o $@

$(BUILD)/kernel.o: kernel/kernel.c | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD)/gdt.o: gdt/gdt.c | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD)/tss.o: gdt/tss.c | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD)/gdt_load.o: gdt/gdt_load.S | $(BUILD)
	$(CC) -c $< -o $@

# =========================
# Clean
# =========================
clean:
	rm -rf $(BUILD) kernel.elf

.PHONY: all clean
