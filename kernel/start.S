/* Marcăm stiva ca non-executabilă */
.section .note.GNU-stack,"",@progbits

/*
 * Header Multiboot 2 pentru FlyOS
 * Acesta trebuie să fie în primii 32KB ai kernel-ului.
 */
.section .multiboot_header
.align 8

/* Constantele magice pentru Multiboot 2 */
.set MULTIBOOT2_HEADER_MAGIC, 0xe85250d6
.set MULTIBOOT_ARCHITECTURE_I386, 0
.set HEADER_LENGTH, multiboot_header_end - multiboot_header_start
.set CHECKSUM, -(MULTIBOOT2_HEADER_MAGIC + MULTIBOOT_ARCHITECTURE_I386 + HEADER_LENGTH)

multiboot_header_start:
    .long MULTIBOOT2_HEADER_MAGIC
    .long MULTIBOOT_ARCHITECTURE_I386
    .long HEADER_LENGTH
    .long CHECKSUM

    /* Tag-ul de final, obligatoriu */
    .word 0 /* type = end tag */
    .word 0 /* flags */
    .long 8 /* size */
multiboot_header_end:

/*
 * Punctul de intrare pentru kernel.
 * GRUB va sări aici după ce încarcă kernel-ul.
 */
.section .text
.global _start
.extern kernel_main
.extern kernel_stack

_start:
    /* Oprim întreruperile până când IDT este gata */
    cli

    /* Setăm stack pointer-ul la vârful stivei definite în kernel.c */
    movq $(kernel_stack + 64 * 1024), %rsp

    /* Salt la funcția principală a kernel-ului */
    call kernel_main