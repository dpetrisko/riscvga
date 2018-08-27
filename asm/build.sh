#!/bin/bash

for i in test_br test_jal test_icache test_imm test_regops test_ldst
do
  riscv32-unknown-elf-gcc src/$i.S -nostdlib -c -o bin/$i.riscv
  riscv32-unknown-elf-objcopy --pad-to=16384 -O verilog bin/$i.riscv vh/$i.vh
done
