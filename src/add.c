#include "fake6502.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern void reset6502(void);
extern void step6502(void);

uint8_t memory[65536];

uint8_t read6502(uint16_t addr) {
    return memory[addr];
}

void write6502(uint16_t addr, uint8_t val) {
    memory[addr] = val;
}

int main() {
    FILE *f = fopen("add.bin", "rb");
    fread(&memory[0x8000], 1, 0x100, f);
    fclose(f);

    memory[0x00] = 5;  // A
    memory[0x01] = 7;  // B

    pc = 0x8000;       // entry point
    for (int i = 0; i < 20; i++) {
        step6502();
        if (pc == 0xFFFF) break; // stop condition (e.g., trap)
    }

    printf("Result: %d\n", memory[0x02]); // should be 12
    return 0;
}
