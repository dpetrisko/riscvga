`include "rvga_types.vh"

module writeback
#(
    `include "rvga_params.vh"
)
(
	input logic clk,
	input logic rst_n,
	
	input logic stall,
	
	input rvga_cword mem_wb_cword,
	
	output rvga_cword wb_if_cword,
	output rvga_cword wb_rf_cword);

rvga_cword temp_cword;

always @* begin
	temp_cword = mem_wb_cword;
end

always @(posedge clk) begin
	if(~rst_n) begin
		wb_rf_cword <= 0;
	end else begin
		if(~stall) begin
			wb_if_cword <= temp_cword;
			wb_rf_cword <= temp_cword;
		end
	end
end

endmodule 

