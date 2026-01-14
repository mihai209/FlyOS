#include "tss.h"

struct tss tss;

void tss_init(uint64_t kernel_stack_top)
{
    __builtin_memset(&tss, 0, sizeof(tss));
    tss.rsp0 = kernel_stack_top;
    tss.iomap_base = sizeof(struct tss);
}
