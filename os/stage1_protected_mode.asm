; FlyOS - Etapa de intrare în Protected Mode
; Acest cod implementează pașii 3 și 4 ai procesului de boot.

BITS 16

; ==============================================================================
; PASUL 3: DEZACTIVAREA ÎNTRERUPERILOR
; ==============================================================================
; Dezactivează întreruperile hardware externe (maskable). Acest pas este
; esențial deoarece tabelele de întreruperi (IVT) din Real Mode sunt
; incompatibile cu cele din Protected Mode (IDT). O întrerupere hardware
; în timpul tranziției ar cauza o eroare fatală (Triple Fault).
cli

; ==============================================================================
; PASUL 4: INTRAREA ÎN PROTECTED MODE
; ==============================================================================

; ------------------------------------------------------------------------------
; 4.1. Încărcarea GDT (Global Descriptor Table)
; ------------------------------------------------------------------------------
; Instrucțiunea 'lgdt' încarcă registrul GDTR cu adresa de bază și limita (dimensiunea)
; tabelei GDT. Procesorul va folosi această tabelă pentru a gestiona segmentele
; de memorie în Protected Mode.
lgdt [gdt_descriptor]

; ------------------------------------------------------------------------------
; 4.2. Activarea Protected Mode
; ------------------------------------------------------------------------------
; Setarea bitului 0 (PE - Protection Enable) din registrul de control CR0
; comandă procesorului să treacă din Real Mode în Protected Mode.
mov eax, cr0
or eax, 0x1      ; Setează bitul PE pe 1
mov cr0, eax

; ------------------------------------------------------------------------------
; 4.3. Salt către codul de 32 de biți (Far Jump)
; ------------------------------------------------------------------------------
; Un 'far jump' este necesar pentru a goli pipeline-ul de instrucțiuni al
; procesorului (care conține instrucțiuni de 16 biți) și pentru a încărca
; registrul CS (Code Segment) cu selectorul segmentului de cod de 32 de biți.
jmp KERNEL_CS:start_protected_mode

; ==============================================================================
; DEFINIȚIA GDT (Global Descriptor Table)
; ==============================================================================
gdt_start:
    ; Descriptor Nul (8 octeți) - obligatoriu
    dd 0x0
    dd 0x0

; Descriptor Segment Cod Kernel (Ring 0) - Selector 0x08
gdt_kernel_code:
    dw 0xFFFF       ; Limita segment (bits 0-15)
    dw 0x0000       ; Baza segment (bits 0-15)
    db 0x00         ; Baza segment (bits 16-23)
    db 0x9A         ; Access Byte: P=1, DPL=00, S=1, Type=Execute/Read
    db 0xCF         ; Flags (G=1, D=1, L=0, AVL=0), Limita (bits 16-19)
    db 0x00         ; Baza segment (bits 24-31)

; Descriptor Segment Date Kernel (Ring 0) - Selector 0x10
gdt_kernel_data:
    dw 0xFFFF       ; Limita segment (bits 0-15)
    dw 0x0000       ; Baza segment (bits 0-15)
    db 0x00         ; Baza segment (bits 16-23)
    db 0x92         ; Access Byte: P=1, DPL=00, S=1, Type=Read/Write
    db 0xCF         ; Flags (G=1, D=1, L=0, AVL=0), Limita (bits 16-19)
    db 0x00         ; Baza segment (bits 24-31)
gdt_end:

; Descriptorul GDT (pointer și limită) pentru instrucțiunea 'lgdt'
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; Limita GDT (dimensiunea totală - 1)
    dd gdt_start               ; Adresa de bază a GDT

; Definiții selectoare - acestea sunt offset-urile descriptorilor de la începutul GDT
KERNEL_CS equ gdt_kernel_code - gdt_start
KERNEL_DS equ gdt_kernel_data - gdt_start


; ==============================================================================
; SECȚIUNE DE COD PE 32 DE BIȚI
; ==============================================================================
[BITS 32]
start_protected_mode:

    ; ------------------------------------------------------------------------------
    ; 4.4. Încărcarea Segmentelor de Date și a Stivei
    ; ------------------------------------------------------------------------------
    ; Încarcă toți registrii de segment de date cu selectorul segmentului de date
    ; al kernel-ului. Nu se poate încărca direct, deci folosim AX ca registru intermediar.
    mov ax, KERNEL_DS
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Inițializează stiva (stack-ul) de 32 de biți.
    ; Registrul ESP (Extended Stack Pointer) trebuie să indice o zonă validă de memorie.
    ; Îl setăm să indice vârful zonei de memorie alocate pentru stivă.
    mov esp, stack_top

    ; ------------------------------------------------------------------------------
    ; 4.5. Test de Confirmare Vizuală
    ; ------------------------------------------------------------------------------
    ; Scrie direct în memoria video VGA (text mode) pentru a confirma vizual
    ; că am intrat cu succes în Protected Mode și că segmentele funcționează.
    mov edi, 0xB8000     ; Adresa de început a memoriei video în text mode
    mov ah, 0x0A          ; Atribut: fundal negru (0), text verde deschis (A)
    mov al, 'O'
    mov [edi], ax         ; Scrie 'O' la prima poziție
    mov al, 'K'
    mov [edi + 2], ax     ; Scrie 'K' la a doua poziție

    ; ------------------------------------------------------------------------------
    ; Buclă de Așteptare
    ; ------------------------------------------------------------------------------
    ; Oprește procesorul pentru a economisi energie. De aici, un kernel real
    ; ar începe inițializarea driverelor și a altor subsisteme.
    inf_loop:
        hlt
        jmp inf_loop

; ==============================================================================
; SECȚIUNEA BSS - DATE NEINIȚIALIZATE
; ==============================================================================
section .bss
    stack_bottom:
        resb 4096 ; Alocă 4KB (o pagină de memorie) pentru stivă
    stack_top:
        ; Eticheta stack_top marchează adresa de după zona alocată,
        ; adică vârful stivei (stack-ul crește descrescător).
