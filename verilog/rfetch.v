`include "debug_defines.vh"
`include "rvga_types.vh"

module rfetch
#(
    `include "rvga_params.vh"
)
(
	input logic clk,
	input logic rst_n,
	
	input logic stall,
	
	input rvga_cword de_rf_cword,
	output rvga_cword rf_ex_cword,
	input rvga_cword wb_rf_cword);

rvga_word regfile[NUM_REGS-1:0];

rvga_cword temp_cword;

always @* begin
	temp_cword = de_rf_cword;
	
	temp_cword.rs1_data = regfile[de_rf_cword.rs1];
	temp_cword.rs2_data = regfile[de_rf_cword.rs2];
end

integer i;
always @(posedge clk) begin
	if(~rst_n) begin
		rf_ex_cword <= 0;
		for(i=0; i<NUM_REGS; i+=1) begin
			regfile[i] <= 0;
		end
	end else begin
		if(~stall) begin
			rf_ex_cword <= temp_cword;
			
			if(wb_rf_cword.regfile_load && wb_rf_cword.rd != 0) begin
				regfile[wb_rf_cword.rd] <= wb_rf_cword.rd_data;
			end
		end
	end
end

endmodule 

