`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

module dff #(parameter width = 1)
  ( input logic clk_i
    , input logic rst_i
    
    , input logic w_v_i
    
    , input logic[width-1:0] data_i
    
    , output logic[width-1:0] data_o
    );

logic[width-1:0] data_r;

always_ff @(posedge clk_i) begin
  if(rst_i) begin
    data_r <= '0;
  end else if(w_v_i) begin
    data_r <= data_i;
  end
end  

assign data_o = data_r;
    
endmodule : dff
