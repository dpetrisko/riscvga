import rvga_types::*;

module writeback_dp #()
  ( input rvga_word pc_i
    , input rvga_word alu_or_ld_result_i
    
    , input logic rdmux_sel_i
    
    , output rvga_word rd_data_o
    );
          
assign rvga_zero = '0;

endmodule : writeback_dp

