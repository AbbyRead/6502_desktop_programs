CC = clang
CFLAGS = -std=c99 -Wall -g -I$(LIB6502)
LDFLAGS =
BIN = bin
OBJ = obj
SRC = src
LIB = lib
LIB6502 = $(LIB)/fake6502

EMULATOR = $(BIN)/emulator
ROM = $(BIN)/hi.bin
ROM_SRC = $(SRC)/hi.asm
ASSEMBLER = xa

OBJ_FILES = $(OBJ)/main.o $(OBJ)/fake6502.o

TEST_BIN = $(BIN)/test_fake6502
TEST_OBJ_FILES = $(OBJ)/tests.o $(OBJ)/fake6502_test.o

.PHONY: all clean run test cppcheck format strip

all: $(EMULATOR) $(ROM)

# Object files
$(OBJ)/main.o: $(SRC)/main.c
	@mkdir -p $(OBJ)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ)/fake6502.o: $(LIB6502)/fake6502.c
	@mkdir -p $(OBJ)
	$(CC) $(CFLAGS) -DNMOS6502 -c $< -o $@

$(EMULATOR): $(OBJ_FILES)
	@mkdir -p $(BIN)
	$(CC) $(CFLAGS) $^ -o $@

$(ROM): $(ROM_SRC)
	@mkdir -p $(BIN)
	$(ASSEMBLER) $< -o $@

run: $(EMULATOR) $(ROM)
	$(EMULATOR) $(ROM)

# Testing
$(OBJ)/tests.o: $(LIB6502)/tests.c
	@mkdir -p $(OBJ)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ)/fake6502_test.o: $(LIB6502)/fake6502.c
	@mkdir -p $(OBJ)
	$(CC) $(CFLAGS) -DDECIMALMODE -DNMOS6502 -c $< -o $@

$(TEST_BIN): $(OBJ)/tests.o $(OBJ)/fake6502_test.o
	@mkdir -p $(BIN)
	$(CC) $(CFLAGS) $^ -o $@

test: $(TEST_BIN)
	valgrind -q ./$(TEST_BIN)

cppcheck:
	cppcheck --enable=all --inconclusive --std=c99 $(SRC) $(LIB6502)

format:
	clang-format -style=file -i $(SRC)/*.{c,h} $(LIB6502)/*.{c,h}

strip:
	strip $(BIN)/*

clean:
	rm -rf $(BIN) $(OBJ)
