`include "rvga_types.sv"
import rvga_types::*;

module memory_stage
  (input logic clk_i
   , input logic rst_i
   
   , input logic stall_v_i
   , input logic flush_v_i
   
   , output logic dmem_r_v_o
   , output logic dmem_w_v_o
   , output rvga_word dmem_addr_o
   , input rvga_word dmem_data_i
   , output rvga_word dmem_data_o
   , input logic dmem_resp_v_i
   );
   
  memory_ctl #()
           ctl();
             
   memory_dp #()
            dp();

endmodule : memory_stage

