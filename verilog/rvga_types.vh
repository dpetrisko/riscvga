`ifndef RVGA_TYPES_VH
`define RVGA_TYPES_VH

typedef logic[31:0] rvga_word;
typedef logic[15:0] rvga_short;
typedef logic[7:0] rvga_byte;

typedef logic[6:0] rvga_opcode;
typedef logic[4:0] rvga_reg;
typedef logic[2:0] rvga_funct3;
typedef logic[6:0] rvga_funct7;

typedef enum logic[1:0] {
	rvga_bwidth,
	rvga_hwidth,
	rvga_wwidth
} rvga_dwidth;

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

typedef enum logic[0:0] {
	rs1mux_reg,
	rs1mux_pc
} rs1mux_selop;

typedef enum logic[1:0] {
	rs2mux_reg,
	rs2mux_imm,
	rs2mux_wordsize,
    rs2mux_reg_5_0
} rs2mux_selop;

typedef enum logic[1:0] {
	rdmux_alu,
	rdmux_imm,
	rdmux_pcplus
} rdmux_selop;

typedef enum logic {
	pcmux_pc,
	pcmux_jmp
} pcmux_selop;

typedef struct packed
{
	rvga_word     pc;
	rvga_word     inst;
	rvga_opcode   opcode;
	rvga_reg      rs1;
	rvga_reg      rs2;
	rvga_reg      rd;
	rvga_funct3   funct3;
	rvga_funct7   funct7;
	
	logic         regfile_load;
	logic         br_enable;
	logic         jal_enable;
	logic         jalr_enable;
	logic         dddr_read;
	logic         dddr_write;
	
	rs1mux_selop rs1mux_sel;
	rs2mux_selop rs2mux_sel;
	pcmux_selop  pcmux_sel;
	
	logic       u_load;
	rvga_dwidth dwidth;
	rvga_aluop  aluop;
	rvga_brop   brop;
	
	rvga_word imm;
	rvga_word rs1_data;
	rvga_word rs2_data;
	rvga_word rd_data;
	rvga_word jmp_tgt;
} rvga_cword;
`endif

