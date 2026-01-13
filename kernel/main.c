#include "stdio.h"

void kmain(void)
{
    vga_clear();
    printf("FlyOS El Torito boot OK\n");

    for (;;)
        __asm__ volatile ("hlt");
}
