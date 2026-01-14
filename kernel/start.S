.global _start
.type _start, @function

_start:
    cli

    /* presupunem că GRUB a setat deja un stack valid;
       dacă vrei control total, îl setăm explicit mai târziu */
    call kernel_main

.hang:
    hlt
    jmp .hang
