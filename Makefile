CC = clang
CFLAGS = -std=c99 -Wall -g -I$(LIB6502)
BIN = bin
OBJ = obj
SRC = src
LIB = lib
LIB6502 = $(LIB)/fake6502

ASSEMBLER = asm6f

ASM_SRCS := $(wildcard $(SRC)/*.asm)
ASM_BINS := $(patsubst $(SRC)/%.asm,$(BIN)/%.bin,$(ASM_SRCS))

C_SRCS := $(wildcard $(SRC)/*.c)
C_BINS := $(patsubst $(SRC)/%.c,$(BIN)/%,$(C_SRCS))
C_OBJS := $(patsubst $(SRC)/%.c,$(OBJ)/%.o,$(C_SRCS))

.PHONY: all clean run test cppcheck format strip

all: $(C_BINS) $(ASM_BINS)

# Assembly programs
$(BIN)/%.bin: $(SRC)/%.asm
	@mkdir -p $(BIN)
	$(ASSEMBLER) $< $@

# Object files for .c files
$(OBJ)/%.o: $(SRC)/%.c
	@mkdir -p $(OBJ)
	$(CC) $(CFLAGS) -c $< -o $@

# fake6502 object file
$(OBJ)/fake6502.o: $(LIB6502)/fake6502.c
	@mkdir -p $(OBJ)
	$(CC) $(CFLAGS) -DNMOS6502 -c $< -o $@

# One binary per C file, linked with fake6502.o
$(BIN)/%: $(OBJ)/%.o $(OBJ)/fake6502.o
	@mkdir -p $(BIN)
	$(CC) $(CFLAGS) $^ -o $@

# Run first program and binary for demo
run: $(BIN)/hi $(BIN)/hi.bin
	$(BIN)/hi $(BIN)/hi.bin

# Testing
$(OBJ)/tests.o: $(LIB6502)/tests.c
	@mkdir -p $(OBJ)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ)/fake6502_test.o: $(LIB6502)/fake6502.c
	@mkdir -p $(OBJ)
	$(CC) $(CFLAGS) -DDECIMALMODE -DNMOS6502 -c $< -o $@

$(BIN)/test_fake6502: $(OBJ)/tests.o $(OBJ)/fake6502_test.o
	@mkdir -p $(BIN)
	$(CC) $(CFLAGS) $^ -o $@

test: $(BIN)/test_fake6502
	valgrind -q ./$(BIN)/test_fake6502

cppcheck:
	cppcheck --enable=all --inconclusive --std=c99 $(SRC) $(LIB6502)

format:
	clang-format -style=file -i $(SRC)/*.{c,h} $(LIB6502)/*.{c,h}

strip:
	strip $(BIN)/*

clean:
	rm -rf $(BIN) $(OBJ)
