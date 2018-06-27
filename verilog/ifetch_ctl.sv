`include "rvga_types.sv"
import rvga_types::*;

module ifetch_ctl
  ( input logic imem_resp_v_i
    , input logic br_v_i
    
    , output logic pc_w_v_o
    , output logic ir_w_v_o
    , output logic pcmux_sel_o
    );
    
always_comb begin
  pc_w_v_o = imem_resp_v_i;
  ir_w_v_o = imem_resp_v_i;
  pcmux_sel_o = br_v_i;
end

endmodule : ifetch_ctl

