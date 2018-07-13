`include "rvga_types.sv"
import rvga_types::*;

module memory_stage
  (input logic clk_i
   , input logic rst_i
   
   , input logic stall_v_i
   , input logic flush_v_i
   
   , input rvga_execute_cword cword_i
   , output rvga_memory_cword cword_o
   
   , output logic dmem_r_v_o
   , output logic dmem_w_v_o
   , output rvga_word dmem_addr_o
   , input rvga_word dmem_data_i
   , output rvga_word dmem_data_o
   , input logic dmem_resp_v_i
   );
 
 logic cmux_sel;
 logic cword_w_v;
   
  memory_ctl #()
          ctl (.stall_v_i(stall_v_i)
               ,.flush_v_i(flush_v_i)
               
               ,.cmux_sel_o(cmux_sel)
               ,.cword_w_v_o(cword_w_v)
               );
              
  memory_dp #()
          dp (.clk_i(clk_i)
              ,.rst_i(rst_i)
          
              ,.cmux_sel_i(cmux_sel)
              ,.cword_w_v_i(cword_w_v)
        
              ,.cword_o(cword_o)
              );

endmodule : memory_stage

