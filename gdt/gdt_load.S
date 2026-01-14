/* Marcăm stiva ca non-executabilă */
.section .note.GNU-stack,"",@progbits

.global gdt_load
.extern gdt_ptr

gdt_load:
    lgdt (gdt_ptr)  # Încarcă GDT-ul folosind pointerul global
    ret