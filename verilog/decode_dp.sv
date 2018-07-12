`include "rvga_types.sv"
import rvga_types::*;

module decode_dp
  ( input logic clk_i
    , input logic rst_i
    
    , input rvga_word pc_i
    , input rvga_word ir_i
    
    , input logic cmux_sel_i
    , input logic cword_w_v_i
    
    , output rvga_decode_cword cword_o
   );
   
rvga_decode_cword cword_n, cword_r, cmux_o;
   
  inst_decoder #()
        decoder (.pc_i(pc_i)
                 ,.ir_i(ir_i)

                 ,.cword_o(cword_n)
                 );

 mux #(.els_p(2)
       ,.width_p($bits(rvga_word))
       )
  cmux(.sel_i(cmux_sel_i)
       ,.i({'0, cword_n})
       ,.o(cmux_o)
       );
                 
  dff #(.width_p($bits(rvga_decode_cword))
        )
 cword (.clk_i(clk_i)
        ,.rst_i(rst_i)
        ,.w_v_i(cword_w_v_i)
        
        ,.i(cmux_o)
        ,.o(cword_r)
        );
        
assign cword_o = cword_r;

endmodule : decode_dp

