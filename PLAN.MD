# FlyOS — PLAN.md

Legend:
✅ = implemented 🔲 = planned 🧪 = experimental

---

## 🟣 BOOT CHAIN (NO GRUB)

### > Stage 0 — MBR (ASM ONLY)

| Step | Task                | Status |
| ---: | ------------------- | ------ |
|    1 | 512B MBR @ `0x7C00` | 🔲     |
|    2 | Stack setup         | 🔲     |
|    3 | Clear screen        | 🔲     |
|    4 | Print boot text     | 🔲     |
|    5 | Disk read (INT 13h) | 🔲     |

---

### > Stage 1 — Loader (ASM ONLY)

| Step | Task                 | Status |
| ---: | -------------------- | ------ |
|    1 | Enable A20           | 🔲     |
|    2 | Temporary GDT        | 🔲     |
|    3 | Disable interrupts   | 🔲     |
|    4 | Enter protected mode | 🔲     |
|    5 | Jump to Stage 2      | 🔲     |

---

### > Stage 2 — Kernel Entry (ASM ONLY)

| Step | Task               | Status |
| ---: | ------------------ | ------ |
|    1 | Switch to 32-bit   | 🔲     |
|    2 | Setup kernel stack | 🔲     |
|    3 | Load kernel image  | 🔲     |
|    4 | Setup segments     | 🔲     |
|    5 | Jump to `kmain()`  | 🔲     |

---

## 🔵 ASM ONLY (CORE HARDWARE)

| Step | Task                   | Status |
| ---: | ---------------------- | ------ |
|    1 | GDT (permanent)        | 🔲     |
|    2 | IDT skeleton           | 🔲     |
|    3 | ISR stubs              | 🔲     |
|    4 | IRQ stubs              | 🔲     |
|    5 | `load_gdt`, `load_idt` | 🔲     |

---

## 🟢 C ONLY (KERNEL CORE)

| Step | Task           | Status |
| ---: | -------------- | ------ |
|    1 | `kmain()`      | 🔲     |
|    2 | Serial logging | 🔲     |
|    3 | Panic handler  | 🔲     |
|    4 | Kernel loop    | 🔲     |
|    5 | Version info   | 🔲     |

---

## 🟢 C ONLY (INTERRUPTS & TIME)

| Step | Task              | Status |
| ---: | ----------------- | ------ |
|    1 | PIC remap         | 🔲     |
|    2 | PIT init          | 🔲     |
|    3 | Timer IRQ handler | 🔲     |
|    4 | `sleep(ms)`       | 🔲     |
|    5 | Uptime counter    | 🔲     |

---

## 🟢 C ONLY (INPUT)

| Step | Task                 | Status |
| ---: | -------------------- | ------ |
|    1 | PS/2 controller init | 🔲     |
|    2 | Keyboard IRQ1        | 🔲     |
|    3 | Scancode map         | 🔲     |
|    4 | Input buffer         | 🔲     |
|    5 | Keyboard test        | 🔲     |

---

## 🟢 C ONLY (MEMORY)

| Step | Task              | Status |
| ---: | ----------------- | ------ |
|    1 | Memory map        | 🔲     |
|    2 | Physical bitmap   | 🔲     |
|    3 | Paging (identity) | 🔲     |
|    4 | Enable paging     | 🔲     |
|    5 | `kmalloc()`       | 🔲     |

---

## 🟢 C ONLY (OUTPUT)

| Step | Task           | Status |
| ---: | -------------- | ------ |
|    1 | VGA text       | 🔲     |
|    2 | Scrolling      | 🔲     |
|    3 | Cursor         | 🔲     |
|    4 | Serial console | 🔲     |
|    5 | Panic screen   | 🔲     |

---

## 🟢 C ONLY (SHELL)

| Step | Task             | Status |
| ---: | ---------------- | ------ |
|    1 | Input loop       | 🔲     |
|    2 | Parser           | 🔲     |
|    3 | Built-in cmds    | 🔲     |
|    4 | Command registry | 🔲     |
|    5 | Help cmd         | 🔲     |

---

## 🟠 PASCAL ONLY (TOOLS)

> **User-space tooling only — never kernel**

| Step | Tool               | Status |
| ---: | ------------------ | ------ |
|    1 | Disk image builder | 🔲     |
|    2 | Kernel packer      | 🔲     |
|    3 | Symbol dumper      | 🔲     |
|    4 | Boot log parser    | 🔲     |
|    5 | Build helper       | 🔲     |


