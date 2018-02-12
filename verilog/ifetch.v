`include "debug_defines.vh"
`include "rvga_types.vh"

module ifetch
#(
    `include "rvga_params.vh"
)
(
	input logic clk,
	input logic rst_n,
	
	input logic stall,
	
	output rvga_word iddr_addr,
	output logic iddr_read,
	input rvga_word iddr_rdata,
	output logic iddr_write,
	output rvga_word iddr_wdata,
	
	output rvga_cword if_de_cword,
	
	input rvga_cword wb_if_cword);

rvga_word pcmux_out;
rvga_word pc;
rvga_cword temp_cword;

always @* begin
	iddr_addr = pc; 
	iddr_read = 1'b1;
	iddr_write = 1'b0;
	iddr_wdata = 32'h0000_0000;
	
	temp_cword = 0;
	temp_cword.pc = pc;
	temp_cword.inst = iddr_rdata;
end

always @(posedge clk) begin
	if(~rst_n) begin
		pc <= 0;
	end else begin
		if(~stall) begin
			pc <= pcmux_out;
			if_de_cword <= temp_cword;
		end
	end
end

mux2 pcmux
(
	.sel(wb_if_cword.pcmux_sel),
	.a(pc + BYTES_PER_WORD),
	.b(wb_if_cword.jmp_tgt),
	
	.f(pcmux_out)
);

endmodule

