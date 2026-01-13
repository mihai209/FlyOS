; FlyOS - Main Bootloader
; This is the first file loaded by the BIOS (MBR).
; Its job is to display system specs and then load Stage1.

BITS 16
ORG 0x7C00

start:
    ; --- Basic Setup ---
    mov [boot_drive], dl ; Save boot drive
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00 ; Stack grows down from our loading address
    sti

    ; --- Screen Setup ---
    mov ah, 0x00
    mov al, 0x03 ; 80x25 text mode
    int 0x10
    call clear_screen

    ; --- Print Header ---
    mov si, boot_msg
    call print_string
    mov si, specs_msg
    call print_string

    ; --- Get CPU Architecture ---
    mov si, arch_msg
    call print_string
    call get_cpu_arch

    ; --- Get RAM Size ---
    mov si, ram_msg
    call print_string
    call get_ram_size

    ; --- Get Storage Info (Placeholder) ---
    mov si, storage_msg
    call print_string
    mov si, storage_placeholder
    call print_string
    call newline

    ; --- Load Stage 1 ---
    mov si, load_msg
    call print_string
    call read_stage1
    jc disk_error

    ; --- Jump to Stage 1 ---
    jmp 0x0000:0x8000

disk_error:
    mov si, err_msg
    call print_string
.hang:
    cli
    hlt
    jmp .hang

; ==============================================================================
; SYSTEM INFO ROUTINES
; ==============================================================================

get_cpu_arch:
    ; Check for CPUID support by trying to flip the ID bit in EFLAGS
    pushfd
    pop eax
    mov ecx, eax
    xor eax, 1 << 21
    push eax
    popfd
    pushfd
    pop eax
    cmp eax, ecx
    je .no_cpuid

    ; CPUID is supported, restore EFLAGS
    push ecx
    popfd

    ; Check for long mode (64-bit) support
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jb .is_32bit

    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29
    jz .is_32bit

    mov si, arch_64
    call print_string
    call newline
    ret

.is_32bit:
    mov si, arch_32
    call print_string
    call newline
    ret

.no_cpuid:
    mov si, arch_unknown
    call print_string
    call newline
    ret

get_ram_size:
    ; Use INT 0x15, AX=E820h to get a memory map
    xor ebx, ebx    ; Start with EBX = 0
    xor edi, edi    ; edi will store total RAM in KB
    mov bp, 0       ; Count of entries
.next_entry:
    mov eax, 0xE820
    mov edx, 0x534D4150 ; 'SMAP'
    mov ecx, 24     ; Request 24 bytes
    mov di, mem_map_buffer
    int 0x15
    jc .done

    ; Check for 'SMAP' signature
    cmp edx, 0x534D4150
    jne .done

    ; Check if this is a usable memory region (type 1)
    mov eax, [mem_map_buffer + 20]
    cmp eax, 1
    jne .skip_entry

    ; Add the size of this region to our total
    ; We'll add the size in KB. The size is in bytes, so divide by 1024.
    mov eax, [mem_map_buffer + 8] ; Low 32 bits of length
    xor edx, edx
    mov cx, 1024
    div cx
    add edi, eax ; Add KB to total

.skip_entry:
    cmp ebx, 0      ; If EBX is 0, we are done
    je .done
    inc bp
    cmp bp, 32 ; Limit to 32 entries to be safe
    je .done
    jmp .next_entry

.done:
    ; Convert total KB to MB and print
    mov eax, edi
    xor edx, edx
    mov ecx, 1024
    div ecx ; EAX = total MB
    call print_dec
    mov si, mb_suffix
    call print_string
    call newline
    ret


; ==============================================================================
; DISK ROUTINES
; ==============================================================================

read_stage1:
    mov di, 3 ; retries
.retry:
    mov ah, 0x02        ; BIOS read sectors
    mov al, 1           ; read 1 sector
    mov ch, 0           ; cylinder 0
    mov cl, 2           ; sector 2
    mov dh, 0           ; head 0
    mov dl, [boot_drive]
    mov bx, 0x8000      ; Load to 0000:8000
    int 0x13
    jnc .read_ok

    ; Reset disk on failure
    mov ah, 0x00
    int 0x13
    dec di
    jnz .retry
    stc ; Set carry flag on final failure
.read_ok:
    ret


; ==============================================================================
; PRINTING ROUTINES
; ==============================================================================

print_string:
    lodsb
    test al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

print_dec:
    ; Prints the value in EAX as a decimal number
    mov ebx, 10
    xor ecx, ecx ; digit counter
.push_digits:
    xor edx, edx
    div ebx
    push dx
    inc ecx
    test eax, eax
    jnz .push_digits
.pop_digits:
    pop dx
    add dl, '0'
    mov ah, 0x0E
    mov al, dl
    int 0x10
    loop .pop_digits
    ret

newline:
    mov si, newline_chars
    call print_string
    ret

clear_screen:
    mov ah, 0x0F
    int 0x10
    mov ah, 0x02
    xor bh, bh
    xor dx, dx
    int 0x10
    ret


; ==============================================================================
; DATA
; ==============================================================================
boot_drive db 0
newline_chars db 13, 10, 0

boot_msg    db "Booting FlyOS", 13, 10, 0
specs_msg   db "System specs:", 13, 10, 0
arch_msg    db "  Arch: ", 0
ram_msg     db "  RAM: ", 0
storage_msg db "  Storage: ", 0
load_msg    db 13, 10, "Loading Stage1...", 0
err_msg     db "Disk read error!", 0

arch_64         db "x86-64", 0
arch_32         db "x86 (32-bit)", 0
arch_unknown    db "Unknown (pre-i486)", 0

storage_placeholder db "Boot drive 0x", 0
mb_suffix       db " MB", 0

section .bss
mem_map_buffer resb 24

times 510-($-$$) db 0
dw 0xAA55
