#include "idt.h"
#include <stddef.h> // Pentru NULL
 
// Declarăm extern stub-urile ISR definite în isr_stubs.S
extern void* isr_stub_table[];
 
// Declarăm extern funcția de încărcare a IDT
extern void idt_load(idt_ptr_t* idt_ptr);

// Tabela IDT propriu-zisă
__attribute__((aligned(16)))
idt_entry_t idt[IDT_ENTRIES];

// Pointerul către IDT
idt_ptr_t idt_ptr;

/*
 * Setează o intrare în IDT.
 *
 * @param num   Indexul intrării în IDT (0-255)
 * @param base  Adresa handler-ului de întrerupere
 * @param sel   Selectorul de segment de cod (0x08)
 * @param flags Atributele (tipul de gate, DPL, etc.)
 */
void idt_set_gate(uint8_t num, uint64_t base, uint16_t sel, uint8_t flags, uint8_t ist) {
    idt[num].offset_low = (base & 0xFFFF);
    idt[num].offset_mid = (base >> 16) & 0xFFFF;
    idt[num].offset_high = (base >> 32) & 0xFFFFFFFF;
 
    idt[num].selector = sel;
    idt[num].ist = ist;
    idt[num].type_attr = flags;
    idt[num].zero = 0;
}

/*
 * Inițializează IDT-ul.
 */
void idt_init(void) {
    // Setăm pointerul IDT
    idt_ptr.limit = sizeof(idt) - 1;
    idt_ptr.base = (uint64_t)&idt;
 
    // Setăm gate-urile pentru primele 32 de excepții
    for (int i = 0; i < 32; i++) {
        uint8_t ist = 0;
        if (i == 8) { // Double Fault
            ist = 1;
        }
        // 0x08 este selectorul de cod din GDT. 0x8E sunt flag-urile pentru un 64-bit interrupt gate.
        idt_set_gate(i, (uint64_t)isr_stub_table[i], 0x08, 0x8E, ist);
    }
 
    // Încărcăm IDT-ul
    idt_load(&idt_ptr);
}