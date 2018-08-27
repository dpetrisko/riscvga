CC  := riscv32-unknown-elf-gcc
CPY := riscv32-unknown-elf-objcopy
DIS := riscv32-unknown-elf-objdump
SHELL := sh -xv

CPYFLAGS := -O verilog --pad-to=16384
DISFLAGS := -d

BIN_DIR := bin
VH_DIR  := vh

BIN_FILES := $(wildcard $(BIN_DIR)/%.riscv) 
VH_FILES  := $(patsubst $(ASM_DIR)/%.S,$(VH_DIR)/%.vh,$(BIN_FILES))

$(VH_DIR)/%.vh: $(BIN_DIR)/%.riscv
	$(CPY) $(CPYFLAGS) $< $@

vh: $(VH_FILES)

all: vh

clean:
	rm bin/*.riscv vh/*.vh
