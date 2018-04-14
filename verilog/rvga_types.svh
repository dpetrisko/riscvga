`ifndef RVGA_TYPES_SVH
`define RVGA_TYPES_SVH

timeunit 1ns;
timeprecision 1ns;

parameter ELF_START = 32'h10054;
parameter ELF_SIZE = 1048576;

typedef logic[31:0] rvga_word;
typedef logic[15:0] rvga_short;
typedef logic[7:0] rvga_byte;

typedef logic[6:0] rvga_opcode;
typedef logic[4:0] rvga_reg;
typedef logic[2:0] rvga_funct3;
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

typedef struct packed
{
	rvga_word     pc;
	rvga_opcode   opcode;
	rvga_reg      rs1;
	rvga_reg      rs2;
	rvga_reg      rd;
	rvga_funct3   funct3;
	rvga_funct7   funct7;
	rvga_word     imm;
} rvga_dbg_word;

`endif
