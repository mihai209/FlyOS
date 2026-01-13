#include <stdio.h>

void kmain(void)
{
    vga_clear();
    vga_write("FlyOS kernel alive\n");
    for (;;);
}
