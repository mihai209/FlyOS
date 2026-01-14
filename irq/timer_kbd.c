#include "irq.h"

// Contor global pentru tick-urile de timer
volatile uint64_t timer_ticks = 0;

// Helper inline pentru a citi de la un port
static inline uint8_t inb(uint16_t port) {
    uint8_t ret;
    asm volatile ("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

/**
 * @brief Handler pentru IRQ0 (timer).
 * Incrementează un contor global.
 */
void timer_handler(registers_t* regs) {
    (void)regs; // Nu folosim registrii aici
    timer_ticks++;

    // Exemplu: afișează un punct la fiecare 100 de tick-uri
    // if (timer_ticks % 100 == 0) {
    //     serial_putc('.');
    // }
}

/**
 * @brief Handler pentru IRQ1 (tastatură).
 * Citește scancode-ul de la portul 0x60.
 */
void keyboard_handler(registers_t* regs) {
    (void)regs; // Nu folosim registrii aici
    uint8_t scancode = inb(0x60);

    // Aici s-ar putea procesa scancode-ul
    // De exemplu: serial_printf("sc=0x%x\n", scancode);
}

void timer_kbd_init(void) {
    irq_register_handler(0, timer_handler);
    irq_register_handler(1, keyboard_handler);
}