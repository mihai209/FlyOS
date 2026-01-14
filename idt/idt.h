#ifndef IDT_H
#define IDT_H
 
#include <stdint.h>
 
// Structura unei intrări în IDT (Interrupt Gate) pentru x86-64
typedef struct {
    uint16_t offset_low;    // Biții 0-15 ai adresei handler-ului
    uint16_t selector;      // Selectorul segmentului de cod (de ex. 0x08)
    uint8_t  ist;           // Interrupt Stack Table (0 pentru noi)
    uint8_t  type_attr;     // Tipul și atributele (de ex. 0x8E pentru 64-bit interrupt gate)
    uint16_t offset_mid;    // Biții 16-31 ai adresei 
    uint32_t offset_high;   // Biții 32-63 ai adresei
    uint32_t zero;          // Rezervat
} __attribute__((packed)) idt_entry_t;
 
// Structura pointerului IDT (pentru instrucțiunea LIDT)
typedef struct {
    uint16_t limit;         // Dimensiunea IDT - 1
    uint64_t base;          // Adresa de bază a IDT
} __attribute__((packed)) idt_ptr_t;
 
 
// Numărul total de întreruperi (256)
#define IDT_ENTRIES 256
 
 
// Funcția principală de inițializare a IDT
void idt_init(void);

#endif // IDT_H