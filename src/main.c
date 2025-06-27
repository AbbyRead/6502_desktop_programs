// main.c
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "fake6502.h"

#define MEM_SIZE 0x10000
#define IO_PORT 0xD000

uint8_t memory[MEM_SIZE];
FILE *outfile = NULL;

uint8_t fake6502_mem_read(fake6502_context *c, uint16_t address) {
	return memory[address];
}

void fake6502_mem_write(fake6502_context *c, uint16_t address, uint8_t value) {
	if (address == IO_PORT && outfile) {
		fputc(value, outfile);
	} else {
		memory[address] = value;
	}
}

void load_program(const char *filename, uint16_t load_addr) {
	FILE *f = fopen(filename, "rb");
	if (!f) {
		perror("Failed to open input file");
		exit(1);
	}

	size_t bytes_read = fread(&memory[load_addr], 1, MEM_SIZE - load_addr, f);
	fclose(f);

	printf("Loaded %zu bytes at $%04X\n", bytes_read, load_addr);
}

int main(int argc, char **argv) {
	if (argc < 3) {
		fprintf(stderr, "Usage: %s program.bin output.txt\n", argv[0]);
		return 1;
	}

	load_program(argv[1], 0x0600);

	memory[0xFFFC] = 0x00;
	memory[0xFFFD] = 0x06;

	fake6502_context ctx;
	memset(&ctx, 0, sizeof(ctx));
	ctx.cpu.pc = 0x0600;

	fake6502_reset(&ctx);

	outfile = fopen(argv[2], "w");
	if (!outfile) {
		perror("Failed to open output file");
		return 1;
	}

	for (int i = 0; i < 10000; i++) {
		fake6502_step(&ctx);
		if (ctx.emu.opcode == 0x00) {
			break; // BRK executed
		}
	}


	fclose(outfile);
	printf("Execution completed.\n");
	return 0;
}
