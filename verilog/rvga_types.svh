package rvga_types;

timeunit 1ns;
timeprecision 1ns;

parameter ELF_START = 32'h10054;
parameter ELF_SIZE = 1048576;

typedef logic[127:0] rvga_cacheline;
typedef logic[31:0] rvga_word;
typedef logic[15:0] rvga_short;
typedef logic[7:0] rvga_byte;

typedef enum logic[6:0] {
    rvga_opcode_imm = 7'b1110011
    , rvga_opcode_branch = 7'b1100011
} rvga_opcode;

typedef enum logic[2:0] {
    rvga_funct3_beq = 3'b000
    , rvga_funct3_bne = 3'b001
    , rvga_funct3_blt = 3'b100
    , rvga_funct3_bge = 3'b101
    , rvga_funct3_bltu = 3'b110
    , rvga_funct3_bgeu = 3'b111
} rvga_funct3;

typedef enum logic[2:0] {
    rvga_inst_type_r = 3'b000
    , rvga_inst_type_i = 3'b001
    , rvga_inst_type_s = 3'b010
    , rvga_inst_type_b = 3'b011
    , rvga_inst_type_u = 3'b100
    , rvga_inst_type_j = 3'b101
} rvga_inst_type;

typedef logic[4:0] rvga_reg;
typedef logic[6:0] rvga_funct7;

typedef enum logic[3:0] {
	alu_passa,
	alu_passb,
	alu_add,
	alu_slt,
	alu_sltu,
	alu_and,
	alu_or,
	alu_xor,
	alu_sll,
	alu_srl,
	alu_sra,
	alu_sub
} rvga_aluop; 

typedef enum logic[2:0] {
	br_beq,
	br_bne,
	br_blt,
	br_bltu,
	br_bge,
	br_bgeu
} rvga_brop;

endpackage
