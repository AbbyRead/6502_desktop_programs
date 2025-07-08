
# 6502 Desktop Programs

A collection of C programs that embed a 6502 CPU emulator to run small assembly routines. Useful for experimentation, learning 6502 assembly, and understanding emulator integration.

## 📘 About

- Uses the [`fake6502`](https://github.com/ivop/fake6502) CPU emulator (included as a Git submodule)
- Compiles and runs 6502 assembly programs from the desktop
- Currently includes:
- `add.asm` – simple addition routine
- `hi.asm` – example program with output

## ⚙️ Building

1. **Clone the repo with submodules**:

```bash
git clone --recurse-submodules git@github.com:AbbyRead/6502_desktop_programs.git
cd 6502_desktop_programs
```

🔍 If you forget `--recurse-submodules`, run this instead:

```bash
git submodule update --init --recursive
```

2. **Build everything**:

```bash
make
```

3. **Run a test program** (example):

```bash
./add
```

## 🧩 Dependencies

* A C compiler (e.g. `gcc`)
* `make` (GNU Make)

## 📦 Submodules

This project uses the `fake6502` emulator as a Git submodule. If you’re contributing, be sure to keep it up to date with:

```bash
git submodule update --remote
```

## 📄 License

* Your code: [0BSD](./LICENSE) (if you choose to license it)
* `fake6502`: [See its LICENSE file](third_party/fake6502/LICENSE)

