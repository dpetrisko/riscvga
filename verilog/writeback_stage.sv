`include "rvga_types.sv"
import rvga_types::*;

module writeback_stage
  (input logic clk_i
   , input logic rst_i
   
   , input logic stall_v_i
   
   , input rvga_memory_cword cword_i
   , output rvga_writeback_cword cword_o
   
   , output rvga_word br_tgt_o
   , output logic br_v_o
   );
   
logic cword_w_v;   
   
  writeback_ctl #()
           ctl (.stall_v_i(stall_v_i)
                
                ,.cword_w_v_o(cword_w_v)
                );
               
  writeback_dp #()
             dp (.clk_i(clk_i)
                 ,.rst_i(rst_i)
           
                 ,.cword_w_v_i(cword_w_v)
         
                 ,.cword_o(cword_o)
                 );

endmodule : writeback_stage

