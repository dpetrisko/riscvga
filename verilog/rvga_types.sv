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

typedef logic[6:0] rvga_opcode;
typedef logic[2:0] rvga_inst_type;

typedef enum rvga_opcode {
    e_rvga_opcode_err     = 7'b0000000
    , e_rvga_opcode_lui   = 7'b0110111
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

typedef enum rvga_funct3 {
    e_rvga_brop_beq    = 3'b000
    , e_rvga_brop_bne  = 3'b001
    , e_rvga_brop_blt  = 3'b100
    , e_rvga_brop_bge  = 3'b101
    , e_rvga_brop_bltu = 3'b110
    , e_rvga_brop_bgeu = 3'b111
} rvga_brop_e;

typedef enum rvga_funct3 {
    e_rvga_lop_lb    = 3'b000
    , e_rvga_lop_lh  = 3'b001
    , e_rvga_lop_lw  = 3'b010
    , e_rvga_lop_lbu = 3'b100
    , e_rvga_lop_lhu = 3'b101
} rvga_lop_e;

typedef enum rvga_funct3 {
    e_rvga_stop_sb   = 3'b000
    , e_rvga_stop_sh = 3'b001
    , e_rvga_stop_sw = 3'b010
} rvga_stop_e;

typedef rvga_funct3 rvga_artop;
typedef enum rvga_funct3 {
    e_rvga_artop_addsub  = 3'b000
    , e_rvga_artop_sll   = 3'b001 
    , e_rvga_artop_slt   = 3'b010
    , e_rvga_artop_sltu  = 3'b011
    , e_rvga_artop_xor   = 3'b100
    , e_rvga_artop_srx   = 3'b101
    , e_rvga_artop_or    = 3'b110
    , e_rvga_artop_and   = 3'b111
} rvga_artop_e;

typedef enum logic[2:0] {
    e_rvga_inst_type_e = 3'b000
    , e_rvga_inst_type_r = 3'b001
    , e_rvga_inst_type_i = 3'b010
    , e_rvga_inst_type_s = 3'b011
    , e_rvga_inst_type_b = 3'b100
    , e_rvga_inst_type_u = 3'b101
    , e_rvga_inst_type_j = 3'b110
} rvga_inst_type_e;

endpackage

`endif