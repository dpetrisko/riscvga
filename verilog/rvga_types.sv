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
    e_rvga_opcode_imm = 7'b1110011
    , e_rvga_opcode_branch = 7'b1100011
} rvga_opcode_e;

typedef enum logic[2:0] {
    e_rvga_funct3_beq = 3'b000
    , e_rvga_funct3_bne = 3'b001
    , e_rvga_funct3_blt = 3'b100
    , e_rvga_funct3_bge = 3'b101
    , e_rvga_funct3_bltu = 3'b110
    , e_rvga_funct3_bgeu = 3'b111
} rvga_funct3_e;

typedef enum logic[6:0] {
    e_test = 0
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