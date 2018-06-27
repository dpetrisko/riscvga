`include "rvga_types.sv"
import rvga_types::*;

module memory_stage
  (input logic clk_i
   , input logic rst_i
   
   , output logic dmem_r_v_o
   , output logic dmem_w_v_o
   , output rvga_word dmem_addr_o
   , input rvga_word dmem_data_i
   , output rvga_word dmem_data_o
   , input logic dmem_resp_v_i
   );

endmodule : memory_stage

