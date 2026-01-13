; BOOT.ASM — HDD MBR bootloader
BITS 16
ORG 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    mov [boot_drive], dl   ; BIOS ne dă drive-ul corect (0x80)

    mov si, msg_boot
    call print

    ; Disk Address Packet (DAP)
    mov si, dap
    mov ah, 0x42           ; INT 13h Extensions - Read
    mov dl, [boot_drive]
    int 0x13
    jc disk_error

    jmp 0x0000:0x1000

disk_error:
    mov si, msg_err
    call print
    hlt

print:
    lodsb
    test al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print
.done:
    ret

boot_drive db 0

msg_boot db "FlyOS HDD boot...", 0
msg_err  db "Disk read error", 0

; -------------------------
; Disk Address Packet
; -------------------------
dap:
    db 0x10        ; size of DAP
    db 0x00
    dw 4           ; sectors to read (adjust if loader grows)
    dw 0x1000      ; offset
    dw 0x0000      ; segment
    dq 1           ; LBA start (sector 1 = after MBR)

times 510 - ($ - $$) db 0
dw 0xAA55
