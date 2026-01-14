#include "irq.h"
#include "pic.h"
#include <stddef.h> // Pentru NULL

// Tabela de handlere pentru cele 16 linii IRQ
static irq_handler_t irq_handlers[16] = {0};

void irq_init(void) {
    // Remapăm PIC-ul pentru a nu se suprapune cu excepțiile CPU
    pic_remap();

    // Mascăm toate IRQ-urile inițial. Vor fi demascate individual.
    for (int i = 0; i < 16; i++) {
        pic_set_mask(i, 0); // 0 = mask
    }
}

void irq_register_handler(uint8_t irq, irq_handler_t handler) {
    if (irq < 16) {
        irq_handlers[irq] = handler;
        pic_set_mask(irq, 1); // 1 = unmask
    }
}

void irq_unregister_handler(uint8_t irq) {
    if (irq < 16) {
        pic_set_mask(irq, 0); // 0 = mask
        irq_handlers[irq] = NULL;
    }
}

void irq_dispatch(registers_t* regs) {
    // Calculăm numărul IRQ (0-15) din vectorul de întrerupere (32-47)
    uint8_t irq = regs->int_no - 32;

    // Verificăm dacă există un handler înregistrat
    if (irq_handlers[irq] != NULL) {
        irq_handlers[irq](regs);
    } else {
        // Handler pentru IRQ-uri "spurioase" sau neînregistrate
        // Aici s-ar putea loga un mesaj.
    }

    // Trimitem EOI (End of Interrupt) la PIC
    // Este esențial, altfel PIC-ul nu va mai trimite întreruperi pe acea linie.
    pic_send_eoi(irq);
}