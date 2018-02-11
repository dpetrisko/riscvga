`include "rvga_types.vh"

module rvga
#(
    `include "rvga_params.vh"
)
(
	input logic clk,
	input logic rst_n,
	
	output rvga_word iddr_addr,
	output logic iddr_read,
	input rvga_word iddr_rdata,
	output logic iddr_write,
	output rvga_word iddr_wdata,
	input logic iddr_resp,
	
	output rvga_word dddr_addr,
	output logic dddr_read,
	input rvga_word dddr_rdata,
	output logic dddr_write,
	output rvga_word dddr_wdata,
	input logic dddr_resp);

rvga_cword if_de_cword;
rvga_cword de_rf_cword;
rvga_cword rf_ex_cword;
rvga_cword ex_mem_cword;
rvga_cword mem_wb_cword;
rvga_cword wb_if_cword;
rvga_cword wb_rf_cword;

logic stall;

assign stall = ((iddr_read | iddr_write) & ~iddr_resp) || ((dddr_read | dddr_write) & ~dddr_resp); 

ifetch ifetch(.*);

decode decode(.*);

rfetch rfetch(.*);

execute execute(.*);

memory memory(.*);

writeback writeback(.*);

endmodule 

