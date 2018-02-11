`include "rvga_types.vh"

module execute
#(
    `include "rvga_params.vh"
)
(
	input logic clk,
	input logic rst_n,
	
	input logic stall,
	
	input rvga_cword rf_ex_cword,
	output rvga_cword ex_mem_cword);

rvga_cword temp_cword;

rvga_word rs1mux_out;
rvga_word rs2mux_out;
rvga_word alu_out;
rvga_word jmp_tgt;
pcmux_selop pcmux_sel;

always @* begin
	temp_cword = rf_ex_cword;
	temp_cword.rd_data = alu_out;
	temp_cword.jmp_tgt = jmp_tgt;
	temp_cword.pcmux_sel = pcmux_sel;
end

always @(posedge clk) begin
	if(~rst_n) begin
		ex_mem_cword <= 0;
	end else begin
		if(~stall) begin
			ex_mem_cword <= temp_cword;
		end
	end
end

mux2 rs1mux
(
	.sel(rf_ex_cword.rs1mux_sel),
	.a(rf_ex_cword.rs1_data),
	.b(rf_ex_cword.imm),
	
	.f(rs1mux_out)
);

mux4 rs2mux
(
	.sel(rf_ex_cword.rs2mux_sel),
	.a(rf_ex_cword.rs2_data),
	.b(rf_ex_cword.imm),
	.c(32'h0000_0004),
	.d(),
	
	.f(rs2mux_out)
);


alu alu
(
	.a(rs1mux_out),
	.b(rs2mux_out),
	.aluop(temp_cword.aluop),
	
	.f(alu_out)
);

br_calc br_calc
(
	.br_enable(temp_cword.br_enable),
	.jal_enable(temp_cword.jal_enable),
	.jalr_enable(temp_cword.jalr_enable),
	.brop(temp_cword.brop),
	
	.pc(temp_cword.pc),
	.imm(temp_cword.imm),
	.rs1_data(temp_cword.rs1_data),
	.rs2_data(temp_cword.rs2_data),
	
	.jmp_tgt(jmp_tgt),
	.pcmux_sel(pcmux_sel)
);

endmodule

