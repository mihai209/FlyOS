/* Marcăm stiva ca non-executabilă */
.section .note.GNU-stack,"",@progbits

.global idt_load

idt_load:
    lidt (%rdi)     # Încarcă IDT-ul folosind pointerul primit în %rdi
    ret             # Revine la funcția C