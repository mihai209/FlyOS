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
	$(BUILD)/kernel.o \
	$(BUILD)/gdt.o \
	$(BUILD)/gdt_load.o \
	$(BUILD)/tss.o \
	$(BUILD)/idt.o \
	$(BUILD)/idt_load.o \
	$(BUILD)/exceptions.o \
	$(BUILD)/isr_stubs.o \
	$(BUILD)/panic.o \
	$(BUILD)/pic.o \
	$(BUILD)/irq.o \
	$(BUILD)/timer_kbd.o


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

$(BUILD)/idt.o: idt/idt.c | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD)/idt_load.o: idt/idt_load.S | $(BUILD)
	$(CC) -c $< -o $@

$(BUILD)/isr_stubs.o: idt/isr_stubs.S | $(BUILD)
	$(CC) -c $< -o $@

$(BUILD)/panic.o: panic/panic.c panic/panic.h | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD)/exceptions.o: idt/exceptions.c idt/isr.h | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD)/pic.o: irq/pic.c irq/pic.h | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD)/irq.o: irq/irq.c irq/irq.h irq/pic.h idt/isr.h | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD)/timer_kbd.o: irq/timer_kbd.c irq/irq.h idt/isr.h | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

# =========================
# Clean
# =========================
clean:
	rm -rf $(BUILD) kernel.elf

.PHONY: all clean
