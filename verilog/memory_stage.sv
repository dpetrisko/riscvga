`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

module memory_stage
  ( input logic clk
    , input logic rst
    
    , input logic execute_memory_rd_w_v
    , input rvga_reg execute_memory_rd
    , input rvga_word execute_memory_result
    
    , output logic memory_writeback_rd_w_v
    , output rvga_reg memory_writeback_rd
    , output rvga_word memory_writeback_result
    
    , rvga_membus_io.master membus_if_io
    
    `ifdef INST_DEBUG_BUS
    , rvga_debug_io debug_if_i
    , rvga_debug_io debug_if_o
    `endif
    );

always_ff @(posedge clk) begin
  `ifdef INST_DEBUG_BUS
    debug_if_o <= debug_if_i;
  `endif
  
  memory_writeback_rd_w_v <= execute_memory_rd_w_v;
  memory_writeback_rd <= execute_memory_rd;
  memory_writeback_result <= execute_memory_result;
end

always_comb begin
  membus_if_io.addr_o = 0;
  membus_if_io.read_o = 0;
  membus_if_io.write_o = 0;
  membus_if_io.wdata_o = 0;
end

endmodule : memory_stage
