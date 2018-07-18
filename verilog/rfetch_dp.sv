`include "rvga_types.sv"
import rvga_types::*;

module rfetch_dp
  ( input logic clk_i
    , input logic rst_i
    
    , input rvga_reg rs1_i
    , input rvga_reg rs2_i
    
    , output rvga_word rs1_data_o
    , output rvga_word rs2_data_o
    
    , input logic writeback_rd_w_v_i
    , input rvga_reg writeback_rd_i
    , input rvga_word writeback_rd_data_i
    );
    
  regfile #(.width_p($bits(rvga_word))
            ,.els_p(32)
            )
   regfile (.clk_i(clk_i)
            ,.rst_i(rst_i)
        
            ,.rd_w_v_i(writeback_rd_w_v_i)
            ,.rd_i(writeback_rd_i)
            ,.rd_data_i(writeback_rd_data_i)
        
            ,.rs1_i(rs1_i)
            ,.rs1_data_o(rs1_data_o)
        
            ,.rs2_i(rs2_i)
            ,.rs2_data_o(rs2_data_o)
            );

endmodule : rfetch_dp

