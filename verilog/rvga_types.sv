`ifndef RVGA_TYPES_SV
`define RVGA_TYPES_SV 

package rvga_types;

timeunit 1ns;
timeprecision 1ns;

parameter ELF_START = 32'h10054;
parameter ELF_SIZE = 1048576;

typedef logic[127:0] rvga_cacheline;
typedef logic[31:0] rvga_word;
typedef logic[4:0] rvga_reg;
typedef logic[15:0] rvga_short;
typedef logic[7:0] rvga_byte;

typedef enum logic[6:0] {
    e_rvga_opcode_lui     = 7'b0110111
    , e_rvga_opcode_auipc = 7'b0010111
    , e_rvga_opcode_jal   = 7'b1101111
    , e_rvga_opcode_jalr  = 7'b1100111
    , e_rvga_opcode_br    = 7'b1100011
    , e_rvga_opcode_ld    = 7'b0000011
    , e_rvga_opcode_st    = 7'b0100011
    , e_rvga_opcode_imm   = 7'b0010011
    , e_rvga_opcode_reg   = 7'b0110011
    , e_rvga_opcode_fence = 7'b0001111
    , e_rvga_opcode_misc  = 7'b1110011

} rvga_opcode_e;

typedef logic[2:0] rvga_funct3;
typedef logic[6:0] rvga_funct7;

typedef enum logic[2:0] {
    e_rvga_brop_beq    = 3'b000
    , e_rvga_brop_bne  = 3'b001
    , e_rvga_brop_blt  = 3'b100
    , e_rvga_brop_bge  = 3'b101
    , e_rvga_brop_bltu = 3'b110
    , e_rvga_brop_bgeu = 3'b111
} rvga_brop_e;

typedef enum logic[2:0] {
    e_rvga_lop_lb    = 3'b000
    , e_rvga_lop_lh  = 3'b001
    , e_rvga_lop_lw  = 3'b010
    , e_rvga_lop_lbu = 3'b100
    , e_rvga_lop_lhu = 3'b101
} rvga_lop_e;

typedef enum logic[2:0] {
    e_rvga_stop_sb   = 3'b000
    , e_rvga_stop_sh = 3'b001
    , e_rvga_stop_sw = 3'b010
} rvga_stop_e;

typedef enum logic[2:0] {
    e_rvga_imop_addi    = 3'b000
    , e_rvga_imop_slli  = 3'b001
    , e_rvga_imop_slti  = 3'b010
    , e_rvga_imop_sltiu = 3'b011
    , e_rvga_imop_xori  = 3'b100
    , e_rvga_imop_srxi  = 3'b101
    , e_rvga_imop_ori   = 3'b110
    , e_rvga_imop_andi  = 3'b111
} rvga_imop_e;

typedef enum logic[2:0] {
    e_rvga_rop_addsub  = 3'b000
    , e_rvga_rop_sll   = 3'b001 
    , e_rvga_rop_slt   = 3'b010
    , e_rvga_rop_sltu  = 3'b011
    , e_rvga_rop_xor   = 3'b100
    , e_rvga_rop_srx   = 3'b101
    , e_rvga_rop_or    = 3'b110
    , e_rvga_rop_and   = 3'b111
} rvga_rop_e;

typedef enum logic[6:0] {

    e_rvga_funct7_srl = 7'b0000000
/*
    , e_rvga_funct7_sra = 7'b0100000    
    , e_rvga_funct7_add = 7'b0000000
    , e_rvga_funct7_sub = 7'b0100000
    , e_rvga_funct7_sll = 7'b0000000
    , e_rvga_funct7_slt = 7'b0000000
    , e_rvga_funct7_sltu = 7'b0000000
    , e_rvga_funct7_xor = 7'b0000000
    , e_rvga_funct7_or = 7'b0000000
    , e_rvga_funct7_and = 7'b0000000
    */
} rvga_funct7_e;

typedef enum logic[2:0] {
    e_rvga_inst_type_r = 3'b000
    , e_rvga_inst_type_i = 3'b001
    , e_rvga_inst_type_s = 3'b010
    , e_rvga_inst_type_b = 3'b011
    , e_rvga_inst_type_u = 3'b100
    , e_rvga_inst_type_j = 3'b101
} rvga_inst_type_e;

endpackage

`endif