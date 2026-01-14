#ifndef PANIC_H
#define PANIC_H

#include "../idt/isr.h" // Pentru structura registers_t

// Funcția de panică a kernel-ului. Oprește sistemul într-un mod sigur.
// Acest atribut informează compilatorul că funcția nu se va întoarce.
__attribute__((noreturn))
void kernel_panic(registers_t* regs, const char* message);

#endif // PANIC_H