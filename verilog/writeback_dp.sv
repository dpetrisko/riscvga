`include "rvga_types.sv"
import rvga_types::*;

module writeback_dp #()
  ( input rvga_word pc_i
    , input rvga_word ld_result_i
    , input rvga_word alu_result_i
    
    , input logic[1:0] rdmux_sel_i
    
    , output rvga_word rd_data_o
    );

rvga_word pc_plus4;

  mux #(.els_p(4)
        ,.width_p($bits(rvga_word))
        )
 rdmux (.sel_i(rdmux_sel_i)
        ,.i({'0, ld_result_i, pc_plus4, alu_result_i})
        ,.o(rd_data_o)
        );    
    
  adder #(.width_p($bits(rvga_word)))
  pc_inc (.a_i(pc_i)
          ,.b_i(32'd4)
          ,.o(pc_plus4)
          );   

endmodule : writeback_dp

