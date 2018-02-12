`include "debug_defines.vh"
`include "rvga_types.vh"

module decode
#(
    `include "rvga_params.vh"
)
(
	input logic clk,
	input logic rst_n,
	
	input logic stall,
	
	input rvga_cword if_de_cword,
	output rvga_cword de_rf_cword);

rvga_cword temp_cword;

always @* begin
	temp_cword = if_de_cword;
	temp_cword.inst = if_de_cword.inst;
	temp_cword.opcode = if_de_cword.inst[6:0];
	temp_cword.rs1 = if_de_cword.inst[19:15];
	temp_cword.rs2 = if_de_cword.inst[24:20];
	temp_cword.rd = if_de_cword.inst[11:7];
	temp_cword.funct3 = if_de_cword.inst[14:12];
	temp_cword.funct7 = if_de_cword.inst[31:25];
	
	temp_cword.regfile_load = 0;
	temp_cword.br_enable = 0;
	temp_cword.jal_enable = 0;
	temp_cword.jalr_enable = 0;
	temp_cword.dddr_read = 0;
	temp_cword.dddr_write = 0;
	
	temp_cword.rs1mux_sel = rs1mux_reg;
	temp_cword.rs2mux_sel = rs2mux_reg;
	temp_cword.pcmux_sel = pcmux_pc;
	
	temp_cword.u_load = 0;
	temp_cword.dwidth = 0;
	temp_cword.aluop = 0;
	temp_cword.brop = 0;
	
	temp_cword.imm = 0;
	temp_cword.rs1_data = 0;
	temp_cword.rs2_data = 0;
	temp_cword.rd_data = 0;
	temp_cword.jmp_tgt = 0;
	
	case(temp_cword.opcode) 
		OP_LUI:    begin
			temp_cword.imm = { if_de_cword.inst[31:12], 12'b0 };
			temp_cword.aluop = alu_passb;
			temp_cword.rs2mux_sel = rs2mux_imm;
			temp_cword.regfile_load = 1'b1;
		end
		
		OP_AUIPC:  begin
			temp_cword.imm = { if_de_cword.inst[31:12], 12'b0 };
			temp_cword.aluop = alu_add;
			temp_cword.rs1mux_sel = rs1mux_pc;
			temp_cword.rs2mux_sel = rs2mux_imm;
			temp_cword.regfile_load = 1'b1;
		end
		
		OP_JAL:    begin
			temp_cword.imm = { 11'b0, if_de_cword.inst[31], if_de_cword.inst[19:12], if_de_cword.inst[20], if_de_cword.inst[30:21], 1'b0 };
			temp_cword.aluop = alu_add;
			temp_cword.rs1mux_sel = rs1mux_pc;
			temp_cword.rs2mux_sel = rs2mux_wordsize;
			temp_cword.jal_enable = 1'b1;
			temp_cword.regfile_load = 1'b1;
		end
		
		OP_JALR:   begin
			temp_cword.imm = { 20'b0, if_de_cword.inst[31:20] };		
			temp_cword.aluop = alu_add;
			temp_cword.rs2mux_sel = rs2mux_wordsize;
			temp_cword.jalr_enable = 1'b1;
			temp_cword.regfile_load = 1'b1;
		end
		
		OP_BR:     begin
			temp_cword.imm = { 19'b0, if_de_cword.inst[31], if_de_cword.inst[7], if_de_cword.inst[30:25], if_de_cword.inst[11:8], 1'b0 };
			case(temp_cword.funct3)
				FN3_BEQ:  temp_cword.brop = br_beq;
				
				FN3_BNE:  temp_cword.brop = br_bne;
				
				FN3_BLT:  temp_cword.brop = br_blt;
				
				FN3_BLTU: temp_cword.brop = br_bltu;
				
				FN3_BGE:  temp_cword.brop = br_bge;
				
				FN3_BGEU: temp_cword.brop = br_bgeu;
				
				default:  temp_cword.brop = br_beq;
			endcase
			
			temp_cword.br_enable = 1'b1;
		end
		
		OP_LD:     begin
			temp_cword.imm = { 20'b0, if_de_cword.inst[31:20] };
			temp_cword.dddr_read = 1'b1;
			temp_cword.regfile_load = 1'b1;
			case(temp_cword.funct3)
				FN3_LB: temp_cword.dwidth = rvga_bwidth;
				FN3_LH: temp_cword.dwidth = rvga_hwidth;
				FN3_LW: temp_cword.dwidth = rvga_wwidth;
				FN3_LBU: begin 
						temp_cword.dwidth = rvga_bwidth; 
						temp_cword.u_load = 1; 
					end
				FN3_LHU: begin 
						temp_cword.dwidth = rvga_hwidth;
						temp_cword.u_load = 1;
					end
				default: temp_cword.dwidth = rvga_wwidth;
			endcase
		end
		
		OP_ST:     begin
			temp_cword.imm = { 20'b0, if_de_cword.inst[31:25], if_de_cword.inst[11:7] };
			temp_cword.dddr_write = 1'b1;	
			case(temp_cword.funct3)
				FN3_SB:  temp_cword.dwidth = rvga_bwidth;
				FN3_SH:  temp_cword.dwidth = rvga_hwidth;
				FN3_SW:  temp_cword.dwidth = rvga_wwidth;
				default: temp_cword.dwidth = rvga_wwidth;
			endcase
		end
		
		OP_IMM:    begin
			temp_cword.imm = { 20'b0, if_de_cword.inst[31:20] };
			temp_cword.rs2mux_sel = rs2mux_imm;
			temp_cword.regfile_load = 1'b1;
			case(temp_cword.funct3)
				FN3_ADDI: temp_cword.aluop = alu_add;
				
				FN3_SLTI: temp_cword.aluop = alu_slt;
				
				FN3_SLTIU: temp_cword.aluop = alu_sltu;
				
				FN3_ANDI: temp_cword.aluop = alu_and;
				
				FN3_ORI: temp_cword.aluop = alu_or;
				
				FN3_XORI: temp_cword.aluop = alu_xor;
				
				FN3_SLLI: temp_cword.aluop = alu_sll;
				
				FN3_SRL, FN3_SRA:  temp_cword.aluop = temp_cword.funct7 == FN7_SRLI ? alu_srl : alu_sra; 
			endcase	
		end
		
		OP_OP:     begin
			temp_cword.regfile_load = 1'b1;
			case(temp_cword.funct3)
				FN3_ADD, FN3_SUB: temp_cword.aluop = temp_cword.funct7 == FN7_ADD ? alu_add : alu_sub;
				
				FN3_SLT: temp_cword.aluop = alu_slt;
				
				FN3_SLTU: temp_cword.aluop = alu_sltu;
				
				FN3_AND: temp_cword.aluop = alu_and;
				
				FN3_OR: temp_cword.aluop = alu_or;
				
				FN3_XOR: temp_cword.aluop = alu_xor;
				
				FN3_SLL: temp_cword.aluop = alu_sll;
				
				FN3_SRL, FN3_SRA: temp_cword.aluop = temp_cword.funct7 == FN7_SRLI ? alu_srl : alu_sra;		
			endcase
		end
		
		OP_FENCE:  begin
			temp_cword = 0;
			$display("FENCE opcode not implemented\n");
		end
		
		OP_SYSTEM: begin
			temp_cword = 0;	
			$display("SYSTEM opcode not implemented\n");
		end
		
		default: begin
			temp_cword = 0;
			$display("Bad opcode found: %x\n", temp_cword.opcode);
		end
	endcase
end

always @(posedge clk) begin
	if(~rst_n) begin
		de_rf_cword <= 0;
	end else begin
		if(~stall) begin
			de_rf_cword <= temp_cword;
		end
	end
end

endmodule

