`include "rvga_types.sv"
import rvga_types::*;

module mux2 #(parameter width = 32)
  ( input logic sel
	, input logic[width-1:0] a_i
	, input logic[width-1:0] b_i
	, output logic[width-1:0] f_o
    );

always @* begin
  case(sel) 
	1'b0: f_o = a_i;
	1'b1: f_o = b_i;
  endcase
end

endmodule : mux2
