`include "rvga_types.sv"
import rvga_types::*;

module decode_stage
  (input logic clk_i
   , input logic rst_i
   
   , input logic stall_v_i
   , input logic flush_v_i
   
   , input rvga_word pc_i
   , input rvga_word ir_i
   
   , output rvga_decode_cword cword_o
   );
   
logic cmux_sel;
logic cword_w_v;
rvga_decode_cword decoded, cword_n, cword_r, cmux_o;
   
decode_ctl #()
        ctl (.stall_v_i(stall_v_i)
             ,.flush_v_i(flush_v_i)
             
             ,.cmux_sel_o(cmux_sel)
             ,.cword_w_v_o(cword_w_v)
             );
             
decode_dp #()
        dp (.clk_i(clk_i)
            ,.rst_i(rst_i)
            
            ,.pc_i(pc_i)
            ,.ir_i(ir_i)
            
            ,.decoded_o(decoded)
            );
            
 mux #(.els_p(2)
       ,.width_p($bits(rvga_decode_cword))
       )
  cmux(.sel_i(cmux_sel)
       ,.i({'0, cword_n})
       ,.o(cmux_o)
       );
                 
 dff #(.width_p($bits(rvga_decode_cword))
       )
cword (.clk_i(clk_i)
       ,.rst_i(rst_i)
       ,.w_v_i(cword_w_v)
        
       ,.i(cmux_o)
       ,.o(cword_r)
       );

always_comb begin
  cword_n = decoded;
  
  cword_o = cword_r;
end

endmodule : decode_stage
