`include "debug_defines.vh"
`include "rvga_types.vh"

module memory
#(
    `include "rvga_params.vh"
)
(
	input logic clk,
	input logic rst_n,
	
	input logic stall,
	
	output rvga_word dddr_addr,
	output logic dddr_read,
	input rvga_word dddr_rdata,
	output logic dddr_write,
	output rvga_word dddr_wdata,
	input logic dddr_resp,
	
	input rvga_cword ex_mem_cword,
	output rvga_cword mem_wb_cword);

rvga_cword temp_cword;

always @* begin
	temp_cword = ex_mem_cword;
	
	dddr_addr = ex_mem_cword.imm + ex_mem_cword.rs1_data;
	dddr_read = ex_mem_cword.dddr_read;
	dddr_write = ex_mem_cword.dddr_write;
	dddr_wdata = ex_mem_cword.rs2_data;
	
    
	if(dddr_read && dddr_resp) begin
		if(ex_mem_cword.dwidth == rvga_bwidth) begin
			temp_cword.rd_data = { 24'b0, dddr_rdata[7:0] };
		end else if(ex_mem_cword.dwidth == rvga_hwidth) begin
			temp_cword.rd_data = { 16'b0, dddr_rdata[15:0] };
		end else if(ex_mem_cword.dwidth == rvga_wwidth) begin
			temp_cword.rd_data = {        dddr_rdata[31:0] };
		end
	end
end

always @(posedge clk) begin
	if(~rst_n) begin
		mem_wb_cword <= 0;
	end else begin
		if(~stall) begin
			mem_wb_cword <= temp_cword;
		end
	end
end

endmodule 

