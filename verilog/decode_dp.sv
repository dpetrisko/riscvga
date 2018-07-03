`include "rvga_types.sv"
import rvga_types::*;

module decode_dp
  ( input logic clk_i
    , input logic rst_i
    
    , input rvga_word ir_i
    
    , input logic cword_w_v_i
    
    , output rvga_decode_cword cword_o
   );
   
rvga_decode_cword cword_n, cword_r;
   
  inst_decoder #()
        decoder (.ir_i(ir_i)

                 ,.cword_o(cword_n)
                 );
                 
  dff #(.width_p($bits(rvga_decode_cword)))
  cword (.clk_i(clk_i)
        ,.rst_i(rst_i)
        ,.w_v_i(cword_w_v_i)
        
        ,.i(cword_n)
        ,.o(cword_r)
        );
        
always_comb begin
  cword_o = cword_r;
end

endmodule : decode_dp

