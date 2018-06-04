`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

module writeback_stage
  ( input logic clk_i
    , input logic rst_i
    
    , input rvga_reg memory_rd
    , input rvga_word memory_result
    , rvga_cword_s cword_i
    
    , output rvga_word writeback_pc_target
    
    , output rvga_reg writeback_rd
    , output rvga_word writeback_rd_data
    , output logic writeback_rd_w_v
    
    , rvga_cword_s cword_o
    
    , input rvga_dword_s dword_i
    , output rvga_dword_s dword_o
    );

always_ff @(posedge clk_i) begin
  writeback_pc_target <= memory_result;
  
  if (rst_i) begin 
    writeback_pc_target <= 32'b0;
    writeback_rd <= 5'b0;
    writeback_rd_data <= 32'b0;
    writeback_rd_w_v <= 1'b0;
    
    cword_o <= '0;
    dword_o <= '0;
  end else begin
    writeback_pc_target <= 32'b0;
    writeback_rd <= memory_rd;
    writeback_rd_data <= memory_result;
    writeback_rd_w_v <= cword_i.rd_w_v;
    
    cword_o <= cword_i;
    dword_o <= dword_i;
  end
end

always_comb begin

end

endmodule : writeback_stage
