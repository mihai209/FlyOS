# 🧭 Roadmap OS UEFI (C-centric, asm izolat)

## Legendă

* `[ ]` neimplementat
* `[x]` implementat / stabil
* `[~]` parțial / experimental

---

## PHASE 0 — Mediu și toolchain (o singură dată)

| Status | Task                         | Detalii / Criteriu de acceptare                       |
| ------ | ---------------------------- | ----------------------------------------------------- |
| [x]    | Instalare clang freestanding | `clang --target=x86_64-elf -ffreestanding` funcțional |
| [x]    | Instalare lld                | Linkare ELF fără GNU ld                               |
| [x]    | Instalare GNU binutils       | `objdump`, `nm`, `readelf` disponibile                |
| [x]    | Instalare QEMU + OVMF        | Boot UEFI funcțional în QEMU                          |
| [x]    | Structură proiect            | `boot/ kernel/ user/ tools/`                          |
| [x]    | Build system                 | `make all` sau `ninja` fără erori                     |
| [x]    | Script QEMU                  | Boot automat cu OVMF + disk FAT                       |

---

## PHASE 1 — Boot UEFI (C ONLY)

| Status | Task                 | Detalii / Criteriu de acceptare     |
| ------ | -------------------- | ----------------------------------- |
| [ ]    | BOOTX64.EFI pornește | Rulează ca aplicație EFI            |
| [ ]    | Print text UEFI      | `SystemTable->ConOut->OutputString` |
| [ ]    | Acces GOP            | GOP detectat corect                 |
| [ ]    | Framebuffer info     | Base, width, height, pitch valide   |
| [ ]    | Memory map UEFI      | Obținut înainte de ExitBootServices |
| [ ]    | AllocatePages        | Alocare pagini kernel               |
| [ ]    | Load kernel ELF      | ELF64 parse + segmente încărcate    |
| [ ]    | boot_info            | Structură pregătită și populată     |
| [ ]    | ExitBootServices     | Reușit fără fallback                |
| [ ]    | Jump kernel          | Control transferat corect           |

---

## PHASE 2 — ASM MINIMAL (OBLIGATORIU, IZOLAT)

| Status | Task             | Detalii / Criteriu de acceptare |
| ------ | ---------------- | ------------------------------- |
| [ ]    | `kernel_entry.S` | Un singur fișier asm            |
| [ ]    | Stack setat      | `rsp` inițializat manual        |
| [ ]    | Interrupts off   | `cli` executat                  |
| [ ]    | Jump kernel_main | ABI clar definit                |
| [ ]    | Safety loop      | `hlt` dacă kernelul revine      |

---

## PHASE 3 — Kernel Core (C ONLY)

| Status | Task                | Detalii / Criteriu de acceptare |
| ------ | ------------------- | ------------------------------- |
| [ ]    | kernel_main rulează | Control stabil                  |
| [ ]    | Debug framebuffer   | Text fără UEFI                  |
| [ ]    | Paging propriu      | PML4 creat de kernel            |
| [ ]    | No identity map     | Kernel rulează high-half        |
| [ ]    | Page allocator      | Bitmap / freelist funcțional    |
| [ ]    | Heap kernel         | `kmalloc/kfree` minimal         |
| [ ]    | GDT                 | Segmente curate                 |
| [ ]    | IDT                 | Intrări valide                  |
| [ ]    | Timer               | PIT sau APIC ticks              |
| [ ]    | Panic handler       | Determinist, fără UB            |

---

## PHASE 4 — Interrupts & Scheduling

| Status | Task             | Detalii / Criteriu de acceptare |
| ------ | ---------------- | ------------------------------- |
| [ ]    | ISR stubs asm    | Doar entry/exit                 |
| [ ]    | Handler C        | Logică în C                     |
| [ ]    | Context save     | Registre + flags                |
| [ ]    | Scheduler RR     | Determinist                     |
| [ ]    | Kernel threads   | Stivă per task                  |
| [ ]    | Switch controlat | Fără corupție                   |

---

## PHASE 5 — Framebuffer Driver (Kernel, C)

| Status | Task           | Detalii / Criteriu de acceptare |
| ------ | -------------- | ------------------------------- |
| [ ]    | FB map virtual | MMU corect                      |
| [ ]    | putpixel       | Fără tearing                    |
| [ ]    | fill_rect      | Corect și rapid                 |
| [ ]    | blit           | Memcpy optim                    |
| [ ]    | Double buffer  | Elimină flicker                 |
| [ ]    | Clear screen   | O(wh)                           |
| [ ]    | Driver stabil  | Fără glitch-uri                 |

---

## PHASE 6 — Input (Kernel, C)

| Status | Task        | Detalii / Criteriu de acceptare |
| ------ | ----------- | ------------------------------- |
| [ ]    | Tastatură   | PS/2 sau USB HID                |
| [ ]    | Mouse       | Evenimente relative             |
| [ ]    | Normalizare | Key/mouse events                |
| [ ]    | Event queue | Lock-free sau spin              |
| [ ]    | IPC input   | Trimis către userland           |

---

## PHASE 7 — IPC & Userland (C ONLY)

| Status | Task           | Detalii / Criteriu de acceptare |
| ------ | -------------- | ------------------------------- |
| [ ]    | Separare ring3 | User ≠ kernel                   |
| [ ]    | ELF loader     | Procese user                    |
| [ ]    | Procese        | Address space propriu           |
| [ ]    | IPC mesaje     | Copy sau shared                 |
| [ ]    | Syscall ABI    | Stabil, documentat              |
| [ ]    | Input server   | Userland daemon                 |

---

## PHASE 8 — Compositor / GUI Server (Userland, C)

| Status | Task            | Detalii / Criteriu de acceptare |
| ------ | --------------- | ------------------------------- |
| [ ]    | GUI process     | Single authority                |
| [ ]    | Backbuffer      | Per fereastră                   |
| [ ]    | Alpha blending  | Corect                          |
| [ ]    | Z-order         | Determinist                     |
| [ ]    | Invalidation    | Redraw minim                    |
| [ ]    | Cursor software | Fără hardware                   |
| [ ]    | Clipboard       | Opțional                        |

---

## PHASE 9 — Toolkit GUI (C)

| Status | Task           | Detalii / Criteriu de acceptare |
| ------ | -------------- | ------------------------------- |
| [ ]    | Widget system  | Fără RTTI                       |
| [ ]    | Button         | Click events                    |
| [ ]    | Label          | Text static                     |
| [ ]    | Window         | Focus + move                    |
| [ ]    | Event dispatch | Bubbling                        |
| [ ]    | Layout         | Simplu                          |
| [ ]    | Font PSF       | Bitmap                          |

---

## PHASE 10 — Desktop Minimal

| Status | Task            | Detalii / Criteriu de acceptare |
| ------ | --------------- | ------------------------------- |
| [ ]    | Desktop manager | Root window                     |
| [ ]    | Taskbar         | Minimal                         |
| [ ]    | Launcher        | Exec apps                       |
| [ ]    | Demo GUI app    | Showcase                        |
| [ ]    | Shutdown        | ACPI                            |
| [ ]    | Reboot          | Corect                          |

---

## PHASE 11 — Hardening & Cleanup

| Status | Task                | Detalii / Criteriu de acceptare     |
| ------ | ------------------- | ----------------------------------- |
| [ ]    | Audit cod           | Manual                              |
| [ ]    | Zero UB             | Compilare cu `-fsanitize=undefined` |
| [ ]    | Stack guards        | Canary sau shadow                   |
| [ ]    | Panic reproductibil | State dump                          |
| [ ]    | Build reproducibil  | Hash identic                        |
| [ ]    | Documentație        | Internă, tehnică                    |


