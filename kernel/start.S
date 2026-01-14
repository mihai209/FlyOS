.section .multiboot
.align 4

/* Constantele magice pentru Multiboot 1 */
.set MULTIBOOT_HEADER_MAGIC, 0x1BADB002
/* Flags: cerem aliniere la pagină (bit 0) și hartă de memorie (bit 1) */
.set MULTIBOOT_HEADER_FLAGS, 0x03
/* Checksum: -(MAGIC + FLAGS) */
.set MULTIBOOT_CHECKSUM, -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)

/* Structura header-ului */
.long MULTIBOOT_HEADER_MAGIC
.long MULTIBOOT_HEADER_FLAGS
.long MULTIBOOT_CHECKSUM

/*
 * Punctul de intrare pentru kernel.
 * GRUB va sări aici după ce încarcă kernel-ul.
 */
.section .text
.global _start
_start:
    /*
     * Aici adaugi codul tău de inițializare.
     * De exemplu, inițializarea GDT, IDT, etc.
     */

    /* O buclă infinită pentru a opri procesorul momentan */
    cli
    hlt