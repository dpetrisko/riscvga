`include "rvga_types.vh"

module br_calc
#(
    `include "rvga_params.vh"
)
(
	input logic br_enable,
	input logic jal_enable,
	input logic jalr_enable,
	input rvga_brop brop,
	
	input rvga_word pc,
	input rvga_word imm,
	input rvga_word rs1_data,
	input rvga_word rs2_data,
	
	output rvga_word jmp_tgt,
	output pcmux_selop pcmux_sel);

always @* begin
	if(jal_enable) begin
		jmp_tgt = pc + imm;
		jmp_tgt[0] = 0;
		pcmux_sel = pcmux_jmp;
	end else if(jalr_enable) begin
		jmp_tgt = rs1_data + imm;
		jmp_tgt[0] = 0;
		pcmux_sel = pcmux_jmp;
	end else if(br_enable) begin
		case(brop)
			br_beq:  pcmux_sel = (rs1_data == rs2_data) ? pcmux_jmp : pcmux_pc;
			br_bne:  pcmux_sel = (rs1_data != rs2_data) ? pcmux_jmp : pcmux_pc;
			br_blt:  pcmux_sel = (rs1_data <  rs2_data) ? pcmux_jmp : pcmux_pc;
			br_bltu: pcmux_sel = ($unsigned(rs1_data) < $unsigned(rs2_data)) ? pcmux_jmp : pcmux_pc;
			br_bge:  pcmux_sel = (rs1_data >= rs2_data) ? pcmux_jmp : pcmux_pc;
			br_bgeu: pcmux_sel = ($unsigned(rs1_data) >= $unsigned(rs2_data)) ? pcmux_jmp : pcmux_pc;
			default: pcmux_sel = pcmux_pc;
		endcase
		
		jmp_tgt = pc + imm;
		jmp_tgt[0] = 0;
	end else begin
		jmp_tgt = 0;
		pcmux_sel = pcmux_pc;
	end
end

endmodule 

