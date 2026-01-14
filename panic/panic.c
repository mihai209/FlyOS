#include "panic.h"

__attribute__((noreturn))
void kernel_panic(registers_t* regs, const char* message) {
    // Oprește întreruperile pentru a preveni condiții de concurență în timpul panicii.
    asm volatile("cli");

    // Marchează parametrii ca fiind utilizați pentru a elimina avertismentele compilatorului.
    // În viitor, aceștia vor fi folosiți pentru a afișa informații detaliate de debug.
    (void)regs;
    (void)message;

    // Aici va veni codul pentru afișarea mesajului de panică pe ecran sau pe portul serial.
    // Exemplu: serial_printf("KERNEL PANIC: %s\n", message);

    // Oprește complet procesorul într-o buclă infinită.
    for (;;) {
        asm volatile("hlt");
    }
}