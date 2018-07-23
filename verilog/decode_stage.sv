`include "rvga_types.sv"
import rvga_types::*;

module decode_stage
  (input logic clk_i
   , input logic rst_i
   
   , input logic stall_v_i
   , input logic flush_v_i
   
   , input rvga_word pc_i
   , input rvga_word ir_i
   
   , output rvga_execute_cword cword_o
   
   , output logic br_v_o
   );
   
logic cmux_sel;
logic cword_w_v;
rvga_execute_cword decoded, cword_n, cword_r, cmux_o, nop;
   
decode_ctl #()
        ctl (.stall_v_i(stall_v_i)
             ,.flush_v_i(flush_v_i)
             
             ,.cmux_sel_o(cmux_sel)
             ,.cword_w_v_o(cword_w_v)
             );
             
decode_dp #()
        dp (.pc_i(pc_i)
            ,.ir_i(ir_i)
            
            ,.decoded_o(decoded)
            );
            
 mux #(.els_p(2)
       ,.width_p($bits(rvga_execute_cword))
       )
  cmux(.sel_i(cmux_sel)
       ,.i({nop, cword_n})
       ,.o(cmux_o)
       );
                 
 dff #(.width_p($bits(rvga_execute_cword))
       )
cword (.clk_i(clk_i)
       ,.rst_i(rst_i)
       ,.w_v_i(cword_w_v)
        
       ,.i(cmux_o)
       ,.o(cword_r)
       );

assign nop = '0;

always_comb begin
  cword_n = decoded;
  
  cword_o = cword_r;
  
  br_v_o = cword_r.br_v;
end

endmodule : decode_stage
