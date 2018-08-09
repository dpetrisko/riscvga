VLIB := vlib
VLOG := vlog
VSIM := vsim

WORK_DIR := work
SRC_DIR  := src
TST_DIR  := test

SRC_FILES := $(wildcard $(SRC_DIR)/*.sv)
TST_FILES := $(wildcard $(TST_DIR)/*.sv) 

$(BIN_DIR)/%.riscv: $(ASM_DIR)/%.S
	$(CC) $(CFLAGS) -c -o $@ $<

$(VH_DIR)/%.vh: $(BIN_DIR)/%.riscv
	$(CPY) $(CPYFLAGS) $< $@

all : work compile rvga_sim
.PHONY: all

work: 
	if ![ -d "$(WORK_DIR)" ]; then $(VLIB) $(WORK_DIR); fi

compile: 
	$(VLOG) $(SRC_FILES) $(TST_FILES)

rvga_sim:
	$(VSIM) -c +TEST_PROG=$(TEST_PROG) -do "run -all" work.rvga_tb