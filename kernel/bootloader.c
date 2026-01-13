#include "stdio.h"

void bootloader_entry(void) {
    printf("FlyOS C bootloader\n");
    printf("Loading kernel...\n");

    while (1) {
        __asm__ volatile ("hlt");
    }
}
