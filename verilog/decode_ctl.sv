`include "rvga_types.sv"
import rvga_types::*;

module decode_ctl
  ( input logic clk_i
    , input logic rst_i

    , output logic cword_w_v_o
    );
    
always_comb begin
  cword_w_v_o = '1;
end
    
endmodule : decode_ctl

