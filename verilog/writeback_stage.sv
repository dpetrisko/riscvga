`include "rvga_types.sv"
import rvga_types::*;

module writeback_stage
  ( input logic clk
    , input logic rst
    
    `ifdef INST_DEBUG_BUS
    , input rvga_opcode memory_writeback_opcode
    , input rvga_inst_type memory_writeback_inst_type
    , input rvga_funct3 memory_writeback_funct3
    , input rvga_funct7 memory_writeback_funct7
    `endif
    
    , output rvga_word writeback_ifetch_pc_target
    , output logic writeback_ifetch_pc_redirect
    
    , output logic writeback_rfetch_rd_w_v
    , output rvga_reg writeback_rfetch_rd
    , output rvga_word writeback_rfetch_rd_data
    );

always_ff @(posedge clk) begin

end

always_comb begin
  writeback_ifetch_pc_target = 0;
  writeback_ifetch_pc_redirect = 0;
end

endmodule : writeback_stage
