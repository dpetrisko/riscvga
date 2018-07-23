`include "rvga_types.sv"
import rvga_types::*;

module writeback_dp #()
  ( input rvga_word pc_i
    , input rvga_word alu_or_ld_result_i
    
    , input logic rdmux_sel_i
    
    , output rvga_word rd_data_o
    );

rvga_word pc_plus4, rvga_zero;

  mux #(.els_p(2)
        ,.width_p($bits(rvga_word))
        )
 rdmux (.sel_i(rdmux_sel_i)
        ,.i({pc_plus4, alu_or_ld_result_i})
        ,.o(rd_data_o)
        );    
    
  adder #(.width_p($bits(rvga_word)))
  pc_inc (.a_i(pc_i)
          ,.b_i(32'd4)
          ,.o(pc_plus4)
          );   
          
assign rvga_zero = '0;

endmodule : writeback_dp

