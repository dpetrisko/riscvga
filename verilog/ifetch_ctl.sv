`include "rvga_types.sv"
import rvga_types::*;

module ifetch_ctl
  ( input logic br_v_i
    , input logic stall_v_i
    , input logic flush_v_i
    
    , output logic pc_w_v_o
    , output logic ir_w_v_o
    , output logic pcmux_sel_o
    , output logic irmux_sel_o
    );
    
always_comb begin
  pc_w_v_o = ~stall_v_i;
  ir_w_v_o = ~stall_v_i;
  pcmux_sel_o = br_v_i;
  irmux_sel_o = flush_v_i;
end

endmodule : ifetch_ctl

