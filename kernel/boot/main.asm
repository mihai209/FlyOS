BITS 32
GLOBAL _start

_start:
    extern kernel_main
    call kernel_main

.hang:
    hlt
    jmp .hang
