`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

module writeback_stage
  ( input logic clk
    , input logic rst
    
    , input logic memory_writeback_rd_w_v
    , input rvga_reg memory_writeback_rd
    , input rvga_word memory_writeback_result
    
    , output rvga_word writeback_ifetch_pc_target
    , output logic writeback_ifetch_pc_redirect_v
    
    , output logic writeback_rfetch_rd_w_v
    , output rvga_reg writeback_rfetch_rd
    , output rvga_word writeback_rfetch_rd_data
    
    `ifdef INST_DEBUG_BUS
    , rvga_debug_io debug_if_i
    , rvga_debug_io debug_if_o
    `endif
    );

always_ff @(posedge clk) begin
  `ifdef INST_DEBUG_BUS
    debug_if_o <= debug_if_i;
  `endif

  writeback_ifetch_pc_target <= 0;
  writeback_ifetch_pc_redirect_v <= 0;
  
  writeback_rfetch_rd_w_v <= memory_writeback_rd_w_v;
  writeback_rfetch_rd <= memory_writeback_rd;
  writeback_rfetch_rd_data <= memory_writeback_result;
  
  `ifdef INST_TRACE_DEBUG
    $display("Inst: %0s Type: %0s F3: %x F7: %x WB: %x RD: %x Result: %x", memory_writeback_opcode.name()
                                                                         , memory_writeback_inst_type.name()
                                                                         , memory_writeback_funct3
                                                                         , memory_writeback_funct7                                                                             
                                                                         , memory_writeback_rd_w_v
                                                                         , writeback_rfetch_rd
                                                                         , writeback_rfetch_rd_data);
  `endif
end

always_comb begin

end

endmodule : writeback_stage
