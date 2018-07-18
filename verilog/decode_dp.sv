`include "rvga_types.sv"
import rvga_types::*;

module decode_dp
  ( input logic clk_i
    , input logic rst_i
    
    , input rvga_word pc_i
    , input rvga_word ir_i
    
    , input logic cmux_sel_i
    , input logic cword_w_v_i
    
    , output rvga_decode_cword decoded_o
   );
   
  inst_decoder #()
        decoder (.pc_i(pc_i)
                 ,.ir_i(ir_i)

                 ,.decoded_o(decoded_o)
                 );

endmodule : decode_dp

