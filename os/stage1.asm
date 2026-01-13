; FlyOS Stage 1 - Protected Mode Entry
; Loaded by MBR at 0x8000

BITS 16
ORG 0x8000

start:
    ; --- A20 Gate (already enabled by MBR, but let's be sure) ---
    call enable_a20

    ; --- Step 3: Disable Interrupts ---
    ; We disable hardware interrupts before loading the GDT and switching to
    ; protected mode. The old IVT (Interrupt Vector Table) is not valid
    ; in protected mode. A new one (IDT) must be set up before re-enabling interrupts.
    cli

    ; --- Step 4: Enter Protected Mode ---
    ; Load the GDT descriptor into the GDTR register.
    lgdt [gdt_descriptor]

    ; Set the PE (Protection Enable) bit (bit 0) in the CR0 register.
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    ; Far jump to our 32-bit code. This is critical for two reasons:
    ; 1. It flushes the CPU's instruction prefetch pipeline.
    ; 2. It loads the CS (Code Segment) register with our new 32-bit kernel code selector.
    jmp KERNEL_CS:protected_mode_start

; ==============================================================================
; GDT (Global Descriptor Table)
; We include the GDT file here to have access to the gdt_descriptor and selectors.
; ==============================================================================
%include "gdt.asm"

; ==============================================================================
; 32-BIT PROTECTED MODE CODE
; ==============================================================================
BITS 32
protected_mode_start:
    ; Load the data segment registers with our 32-bit kernel data selector.
    ; We cannot load DS directly from a constant, so we use AX as an intermediary.
    mov ax, KERNEL_DS
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Set up the stack. We point ESP to the top of our reserved stack area.
    mov esp, stack_top

    ; --- Visual Confirmation Test ---
    ; Write a character directly to VGA memory to confirm we are in 32-bit mode.
    ; If you see a green 'P' in the top-left corner, it worked.
    mov word [0xB8000], 0x0A50 ; 'P' with green on black background

    ; Infinite loop. The kernel would take over from here.
    hang:
        hlt
        jmp hang

; ==============================================================================
; HELPER FUNCTIONS (16-BIT)
; ==============================================================================
BITS 16
enable_a20:
    in al, 0x92
    or al, 00000010b    ; set A20 bit
    and al, 11111110b   ; keep reset bit clear
    out 0x92, al
    ret

; ==============================================================================
; DATA AND BSS
; ==============================================================================
section .bss
    stack_bottom:
        resb 4096 ; Reserve 4KB for the stack
    stack_top: