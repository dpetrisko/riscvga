CC  := riscv32-unknown-elf-gcc
CPY := riscv32-unknown-elf-objcopy
DIS := riscv32-unknown-elf-objdump
SHELL := sh -xv

CFLAGS   := -nostdlib -march=rv32ima -mabi=ilp32
CPYFLAGS := -O verilog --pad-to=16384
DISFLAGS := -d

ASM_DIR := src
BIN_DIR := bin
VH_DIR  := vh
DIS_DIR := dis

ASM_FILES := $(wildcard $(ASM_DIR)/*.S)
BIN_FILES := $(patsubst $(ASM_DIR)/%.S,$(BIN_DIR)/%.riscv,$(ASM_FILES))
VH_FILES  := $(patsubst $(ASM_DIR)/%.S,$(VH_DIR)/%.vh,$(ASM_FILES))
DIS_FILES := $(patsubst $(ASM_DIR)/%.S,$(DIS_DIR)/%.txt,$(ASM_FILES))

$(BIN_DIR)/%.riscv: $(ASM_DIR)/%.S
	$(CC) $(CFLAGS) -c -o $@ $<

$(VH_DIR)/%.vh: $(BIN_DIR)/%.riscv
	$(CPY) $(CPYFLAGS) $< $@

$(DIS_DIR)/%.txt: $(BIN_DIR)/%.riscv
	$(DIS) $(DISFLAGS) $< > $@

bin: $(BIN_FILES)

vh: $(VH_FILES)

dis: $(DIS_FILES)

all: bin vh dis

clean:
	rm bin/*.riscv vh/*.vh
