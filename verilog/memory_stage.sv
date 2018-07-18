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
 rvga_memory_cword cword_n, cword_r, cmux_o;
   
  memory_ctl #()
          ctl (.stall_v_i(stall_v_i)
               ,.flush_v_i(flush_v_i)
               
               ,.cmux_sel_o(cmux_sel)
               ,.cword_w_v_o(cword_w_v)
               
               ,.dmem_r_v_o(dmem_r_v_o)
               ,.dmem_w_v_o(dmem_w_v_o)
               ,.dmem_resp_v_i(dmem_resp_v_i)
               );
              
  memory_dp #()
          dp (.clk_i(clk_i)
              ,.rst_i(rst_i)
          
              ,.dmem_addr_o(dmem_addr_o)
              ,.dmem_data_i(dmem_data_i)
              ,.dmem_data_o(dmem_data_o)
              );

   mux #(.els_p(2)
         ,.width_p($bits(rvga_memory_cword))
         )
    cmux(.sel_i(cmux_sel)
         ,.i({'0, cword_n})
         ,.o(cmux_o)
         );
                  
   dff #(.width_p($bits(rvga_memory_cword))
         ) 
  cword (.clk_i(clk_i)
        ,.rst_i(rst_i)
        ,.w_v_i(cword_w_v)
         
        ,.i(cmux_o)
        ,.o(cword_r)
        );
        
always_comb begin
  cword_n = cword_i;
  
  cword_o = cword_r;
end

endmodule : memory_stage

