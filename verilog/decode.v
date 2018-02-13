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

always @(posedge clk) begin
    `ifdef DEC_DEBUG
     if(~stall) begin
        case(temp_cword.opcode) 
            OP_LUI:    begin $display("OP: LUI"); end
            OP_AUIPC:  begin $display("OP: AUIPC"); end
            OP_JAL:    begin $display("OP: JAL"); end 
            OP_JALR:   begin $display("OP: JALR"); end
            OP_BR:     begin 
                case(temp_cword.funct3)
                    FN3_BEQ: begin $display("OP: BEQ"); end
                    FN3_BNE: begin $display("OP: BNE"); end
                    FN3_BLT: begin $display("OP: BLT"); end
                    FN3_BLTU: begin $display("OP: BLTU"); end
                    FN3_BGE: begin $display("OP: BGE"); end
                    FN3_BGEU: begin $display("OP: BGEU"); end
                endcase
            end
            OP_LD:     begin
                case(temp_cword.funct3)
                    FN3_LB: begin $display("OP: LB"); end
                    FN3_LH: begin $display("OP: LH"); end
                    FN3_LW: begin $display("OP: LW"); end
                    FN3_LBU: begin $display("OP: LBU"); end
                    FN3_LHU: begin $display("OP: LHU"); end
                endcase
            end
            OP_ST:     begin
                case(temp_cword.funct3)
                    FN3_SB: begin $display("OP: SB"); end
                    FN3_SH: begin $display("OP: SH"); end
                    FN3_SW: begin $display("OP: SW"); end
                endcase
            end
            OP_IMM:    begin
                case(temp_cword.funct3)
                    FN3_ADDI:  begin $write("OP: ADDI "); end
                    FN3_SLTI:  begin $write("OP: SLTI "); end
                    FN3_SLTIU: begin $write("OP: SLTIU"); end
                    FN3_ANDI:  begin $write("OP: ANDI "); end
                    FN3_ORI:   begin $write("OP: ORI  "); end
                    FN3_XORI:  begin $write("OP: XORI "); end
                    FN3_SLLI:  begin $write("OP: SLLI "); end
                    FN3_SRL:   begin if (temp_cword.funct7 == FN7_SRLI) $write("OP: SRL  "); else $write("OP: SRA   "); end 
                endcase	 
                $write(" RD: %d RS1: %d IMM: %d\n", temp_cword.rd, temp_cword.rs1, $signed(temp_cword.imm));
            end
            
            OP_OP:     begin
                case(temp_cword.funct3)
                    FN3_ADD: begin $display("OP: ADD"); end
                    FN3_SUB: begin $display("OP: SUB"); end
                    FN3_SLT: begin $display("OP: SLT"); end
                    FN3_SLTU: begin $display("OP: SLTU"); end
                    FN3_AND: begin $display("OP: AND"); end
                    FN3_OR: begin $display("OP: OR"); end
                    FN3_XOR: begin $display("OP: XOR"); end
                    FN3_SLL: begin $display("OP: SLL"); end
                    FN3_SRL: begin if (temp_cword.funct7 == FN7_SRLI) $display("OP: SRL"); else $display("OP: SRA"); end
                endcase 
            end
            OP_FENCE:  begin $display("FENCE opcode not implemented\n"); end
            
            OP_SYSTEM: begin $display("SYSTEM opcode not implemented\n"); end
        endcase
    end
    `endif
end

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
			temp_cword.imm = $signed({ if_de_cword.inst[31:20] });
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
				
                FN3_SRL, FN3_SRA: temp_cword.aluop = temp_cword.funct7 == FN7_SRLI ? alu_srl : alu_sra;
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
				
                FN3_SLL: begin 
                    temp_cword.aluop = alu_sll;
				    temp_cword.rs2mux_sel = rs2mux_reg_5_0;
                end

                FN3_SRL, FN3_SRA: begin
                    temp_cword.aluop = temp_cword.funct7 == FN7_SRLI ? alu_srl : alu_sra;		
				    temp_cword.rs2mux_sel = rs2mux_reg_5_0;
                end
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
	endcase
end

always @(posedge clk) begin
	if(~rst_n) begin
		de_rf_cword <= 0;
        
        temp_cword <= 0;
	end else begin
		if(~stall) begin
			de_rf_cword <= temp_cword;
		end
	end
end

endmodule

