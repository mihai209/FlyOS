Legendă:
[ ] neimplementat
[x] implementat / stabil
[~] parțial / experimental

PHASE 0 — Mediu și toolchain (o singură dată)

 Instalare clang (x86_64-elf sau clang freestanding)
 Instalare lld
 Instalare GNU binutils (pentru objdump, nm)
 Instalare QEMU cu OVMF (UEFI)
 Structură proiect creată (boot/ kernel/ user/)
 Build system (Makefile sau Ninja) funcțional
 Script de rulare QEMU cu OVMF

PHASE 1 — Boot UEFI (C ONLY)

 Aplicație EFI (BOOTX64.EFI) pornește în QEMU
 Print text pe ecran prin UEFI Console
 Acces la GOP (Graphics Output Protocol)
 Obținere framebuffer (base, width, height, pitch)
 Obținere memory map UEFI
 Alocare memorie cu AllocatePages
 Încărcare kernel ELF din disk
 Pregătire structură boot_info
 ExitBootServices reușit
 Jump în kernel entry

PHASE 2 — ASM MINIMAL (OBLIGATORIU, IZOLAT)

 kernel_entry.S
 Stack setat manual
 Interrupts dezactivate (cli)
 Jump controlat în kernel_main()
 Loop de siguranță (hlt) dacă kernelul iese

PHASE 3 — Kernel Core (C ONLY)

 Kernel pornește și rulează kernel_main
 Print debug pe framebuffer
 Paging propriu inițializat (PML4)
 Identity map eliminat
 Allocator de pagini funcțional
 Heap kernel minimal
 GDT configurat
 IDT configurat
 Timer funcțional (PIT sau APIC)
 Panic handler determinist

PHASE 4 — Interrupts & Scheduling (asm doar pentru stubs)

 ISR stubs în asm
 Handler C pentru interrupts
 Context save/restore corect
 Scheduler simplu (round-robin)
 Task kernel threads
 Trecere controlată între task-uri

PHASE 5 — Framebuffer Driver (Kernel, C)

 Map framebuffer fizic → virtual
 putpixel
 fill_rect
 blit
 Double buffering
 Clear screen
 Driver stabil (fără flicker)

PHASE 6 — Input (Kernel, C)

 Driver tastatură PS/2 sau USB HID
 Driver mouse
 Evenimente normalizate (key, mouse)
 Queue de evenimente
 Trimitere evenimente prin IPC

PHASE 7 — IPC & Userland (C ONLY)

 Separare kernel / userland
 ELF loader userland
 Procese user
 IPC prin mesaje (copy sau shared)
 Syscall ABI stabil
 Server de evenimente input

PHASE 8 — Compositor / GUI Server (Userland, C)

 Proces GUI dedicat
 Backbuffer per fereastră
 Alpha blending
 Z-order
 Redraw invalidation
 Mouse cursor software
 Clipboard (opțional)

PHASE 9 — Toolkit GUI (C)

 Sistem de widget-uri
 Buton
 Label
 Window
 Event dispatch
 Layout simplu
 Font bitmap (PSF)

PHASE 10 — Desktop Minimal

 Desktop manager
 Taskbar minimal
 Launcher aplicații
 Aplicație demo GUI
 Shutdown / reboot

PHASE 11 — Hardening & Cleanup

 Cod auditat
 Zero UB (undefined behavior)
 Stack guards
 Kernel panic reproductibil
 Build reproducibil
 Documentație internă