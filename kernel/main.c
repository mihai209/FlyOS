#include "lib/vga.h"

void kernel_main(void) {
    vga_clear();
    vga_puts("FlyOS booted successfully.\n");
    vga_puts("Minimal kernel online.");

    for (;;)
        __asm__ volatile ("hlt");
}
