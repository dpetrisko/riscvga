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
   
rvga_writeback_cword cmux_o, cword_n, cword_r;
logic cword_w_v;   
   
  writeback_ctl #()
           ctl (.stall_v_i(stall_v_i)
                
                ,.cword_w_v_o(cword_w_v)
                );
               
  writeback_dp #()
             dp (.clk_i(clk_i)
                 ,.rst_i(rst_i)
                 );
                     
 dff #(.width_p($bits(rvga_writeback_cword))
       ) 
cword (.clk_i(clk_i)
       ,.rst_i(rst_i)
       ,.w_v_i(cword_w_v)
       
       ,.i(cword_n)
       ,.o(cword_r)
       );
       
always_comb begin
  cword_n = cword_i;
  
  cword_o = cword_r;
end

endmodule : writeback_stage

