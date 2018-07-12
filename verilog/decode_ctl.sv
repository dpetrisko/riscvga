`include "rvga_types.sv"
import rvga_types::*;

module decode_ctl
  ( input logic stall_v_i
    , input logic flush_v_i

    , output logic cmux_sel_o
    , output logic cword_w_v_o
    );
    
always_comb begin
  cword_w_v_o = ~stall_v_i;

  cmux_sel_o = flush_v_i;
end
    
endmodule : decode_ctl

