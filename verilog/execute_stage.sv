`include "rvga_types.sv"
import rvga_types::*;

module execute_stage
  (input logic clk_i
   , input logic rst_i
   
   , input logic stall_v_i
   , input logic flush_v_i
   
   , input rvga_rfetch_cword cword_i
   , output rvga_execute_cword cword_o
   );
   
   execute_ctl #()
             ctl();
             
   execute_dp #()
             dp();

endmodule : execute_stage

