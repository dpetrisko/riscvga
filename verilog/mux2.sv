`include "rvga_types.sv"
import rvga_types::*;

module mux2 
#(
    parameter width = 32
)
(
	input logic sel,
	input logic[width-1:0] a,
	input logic[width-1:0] b,
	
	output logic[width-1:0] f);

always @* begin
	case(sel) 
		1'b0: f = a;
		1'b1: f = b;
	endcase
end

endmodule 

