#include "fake6502.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

uint8_t memory[65536];

uint8_t fake6502_mem_read(fake6502_context *c, uint16_t addr) {
    return memory[addr];
}

void fake6502_mem_write(fake6502_context *c, uint16_t addr, uint8_t val) {
    memory[addr] = val;
}

int main() {
    FILE *f = fopen("add.bin", "rb");
    if (!f) {
        perror("Failed to open add.bin");
        return 1;
    }

    fread(&memory[0x8000], 1, 0x100, f);
    fclose(f);

    memory[0x00] = 5;  // A
    memory[0x01] = 7;  // B

    // Initialize emulator
	fake6502_context cpu;
    memset(&cpu, 0, sizeof(cpu));
    cpu.cpu.pc = 0x8000;

    // Run
    for (int i = 0; i < 20; i++) {
        fake6502_step(&cpu);
        if (cpu.cpu.pc == 0xFFFF) break;
    }

    printf("Result: %d\n", memory[0x02]); // Should be 12
    return 0;
}
