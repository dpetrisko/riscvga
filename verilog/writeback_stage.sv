`include "rvga_types.sv"
import rvga_types::*;

module writeback_stage
  (input logic clk_i
   , input logic rst_i
   
   , input logic stall_v_i
   
   , output rvga_word br_tgt_o
   , output logic br_v_o
   );
   
  writeback_ctl #()
              ctl();
             
  writeback_dp #()
              dp();

endmodule : writeback_stage

