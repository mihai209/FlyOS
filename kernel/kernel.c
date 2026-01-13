void kernel_entry(void) {
    while (1) {
        __asm__ volatile ("hlt");
    }
}
