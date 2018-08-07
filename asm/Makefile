CC    := C:\Users\Dan\riscv-gcc\bin\riscv-none-embed-gcc
CPY   := C:\Users\Dan\riscv-gcc\bin\riscv-none-embed-objcopy 
SHELL := sh -xv

CFLAGS   := -nostdlib -march=rv32i -mabi=ilp32
CPYFLAGS := -O verilog

ASM_DIR := src
BIN_DIR := bin
VH_DIR  := vh

ASM_FILES := $(wildcard $(ASM_DIR)/*.S)
BIN_FILES := $(patsubst $(ASM_DIR)/%.S,$(BIN_DIR)/%.riscv,$(ASM_FILES))
VH_FILES  := $(patsubst $(ASM_DIR)/%.S,$(VH_DIR)/%.vh,$(ASM_FILES))

$(BIN_DIR)/%.riscv: $(ASM_DIR)/%.S
	$(CC) $(CFLAGS) -c -o $@ $<

$(VH_DIR)/%.vh: $(BIN_DIR)/%.riscv
	$(CPY) $(CPYFLAGS) $< $@

bin: $(BIN_FILES)

vh: $(VH_FILES)

all: bin vh

clean:
	rm bin/*.riscv vh/*.vh