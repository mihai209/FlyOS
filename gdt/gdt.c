#include "gdt.h"
#include "tss.h"

struct __attribute__((packed)) gdt_entry {
    uint16_t limit_low;
    uint16_t base_low;
    uint8_t  base_mid;
    uint8_t  access;
    uint8_t  gran;
    uint8_t  base_high;
};

struct __attribute__((packed)) gdt_tss_entry {
    uint16_t limit_low;
    uint16_t base_low;
    uint8_t  base_mid;
    uint8_t  access;
    uint8_t  gran;
    uint8_t  base_high;
    uint32_t base_upper;
    uint32_t reserved;
};

struct __attribute__((packed)) gdt_ptr {
    uint16_t limit;
    uint64_t base;
};

static struct {
    struct gdt_entry null;
    struct gdt_entry code;
    struct gdt_entry data;
    struct gdt_tss_entry tss;
} gdt;

/* Pointerul GDT, vizibil global pentru a fi accesat din gdt_load.S */
struct gdt_ptr gdt_ptr;

/* Prototipul funcției definite în gdt_load.S */
extern void gdt_load(void);

static void gdt_set_entry(struct gdt_entry* e, uint8_t access)
{
    e->limit_low = 0;
    e->base_low  = 0;
    e->base_mid  = 0;
    e->access    = access;
    e->gran      = 0x20; // L-bit
    e->base_high = 0;
}

void gdt_init(void)
{
    gdt_set_entry(&gdt.code, 0x9A); // kernel code
    gdt_set_entry(&gdt.data, 0x92); // kernel data

    uint64_t base = (uint64_t)&tss;
    uint16_t limit = sizeof(struct tss) - 1;

    gdt.tss.limit_low = limit & 0xFFFF;
    gdt.tss.base_low  = base & 0xFFFF;
    gdt.tss.base_mid  = (base >> 16) & 0xFF;
    gdt.tss.access    = 0x89; // present, TSS
    gdt.tss.gran      = ((limit >> 16) & 0x0F);
    gdt.tss.base_high = (base >> 24) & 0xFF;
    gdt.tss.base_upper = (base >> 32);
    gdt.tss.reserved = 0;

    gdt_ptr.limit = sizeof(gdt) - 1;
    gdt_ptr.base  = (uint64_t)&gdt;

    gdt_load();
}
