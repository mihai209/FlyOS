/* Marcăm stiva ca non-executabilă */
.section .note.GNU-stack,"",@progbits
 
.extern isr_handler
 
/*
 * Macro pentru a crea un stub ISR care NU primește un cod de eroare de la CPU.
 * Împingem un 0 pe stivă pentru a menține consistența.
 */
.macro ISR_NO_ERR_CODE int_no
.global isr\int_no
isr\int_no:
    cli             // Oprește întreruperile (deși CPU o face deja)
    pushq $0        // Cod de eroare fictiv
    pushq $\int_no   // Numărul întreruperii
    jmp isr_common_stub
.endm
 
/*
 * Macro pentru a crea un stub ISR care primește un cod de eroare de la CPU.
 */
.macro ISR_ERR_CODE int_no
.global isr\int_no
isr\int_no:
    cli             // Oprește întreruperile
    pushq $\int_no   // Numărul întreruperii
    jmp isr_common_stub
.endm
 
/* Stub-ul comun pentru toate ISR-urile */
isr_common_stub:
    // Salvează toți registrii generali
    pushq %rax
    pushq %rbx
    pushq %rcx
    pushq %rdx
    pushq %rbp
    pushq %rsi
    pushq %rdi
    pushq %rbx
    pushq %r8
    pushq %r9
    pushq %r10
    pushq %r11
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
 
    movq %rsp, %rdi // Primul argument pentru isr_handler este pointerul la stivă (structura registers_t)
    call isr_handler
 
    // Restaurează registrii
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %r11
    popq %r10
    popq %r9
    popq %r8
    popq %rbx
    popq %rbp
    popq %rsi
    popq %rdi
    popq %rax
 
    addq $16, %rsp  // Curăță de pe stivă numărul întreruperii și codul de eroare
    iretq           // Revine din întrerupere
 
/* Generăm cele 32 de stub-uri pentru excepții */
ISR_NO_ERR_CODE 0
ISR_NO_ERR_CODE 1
ISR_NO_ERR_CODE 2
ISR_NO_ERR_CODE 3
ISR_NO_ERR_CODE 4
ISR_NO_ERR_CODE 5
ISR_NO_ERR_CODE 6
ISR_NO_ERR_CODE 7
ISR_ERR_CODE    8 
ISR_NO_ERR_CODE 9
ISR_ERR_CODE    10 
ISR_ERR_CODE    11 
ISR_ERR_CODE    12 
ISR_ERR_CODE    13 
ISR_ERR_CODE    14 
ISR_NO_ERR_CODE 15
ISR_NO_ERR_CODE 16
ISR_ERR_CODE    17 
ISR_NO_ERR_CODE 18
ISR_NO_ERR_CODE 19
ISR_NO_ERR_CODE 20
ISR_ERR_CODE    21 
ISR_NO_ERR_CODE 22
ISR_NO_ERR_CODE 23
ISR_NO_ERR_CODE 24
ISR_NO_ERR_CODE 25
ISR_NO_ERR_CODE 26
ISR_NO_ERR_CODE 27
ISR_NO_ERR_CODE 28
ISR_NO_ERR_CODE 29
ISR_ERR_CODE    30 
ISR_NO_ERR_CODE 31
 
/*
 * Tabelul cu adresele stub-urilor ISR, folosit de idt.c.
 */
.section .data
.global isr_stub_table
isr_stub_table:
    /* Iterează de la 0 la 31 și adaugă adresa fiecărui stub în tabel */
    .irp num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
        .quad isr\num
    .endr