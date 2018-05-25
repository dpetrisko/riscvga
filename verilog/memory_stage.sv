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
    
    , rvga_cachebus_if.master cachebus_io
    
    `ifdef INST_DEBUG_BUS
    , rvga_debugbus_if.i debugbus_i
    , rvga_debugbus_if.o debugbus_o
    `endif
    );

always_ff @(posedge clk) begin
  `ifdef INST_DEBUG_BUS
    debugbus_o.opcode <= debugbus_i.opcode;
    debugbus_o.inst_type <= debugbus_i.inst_type;  
    debugbus_o.brop <= debugbus_i.brop;
    debugbus_o.ldop <= debugbus_i.ldop;
    debugbus_o.strop <= debugbus_i.strop;
    debugbus_o.artop <= debugbus_i.artop;
  `endif
  
  memory_writeback_rd_w_v <= execute_memory_rd_w_v;
  memory_writeback_rd <= execute_memory_rd;
  memory_writeback_result <= execute_memory_result;
end

always_comb begin
  cachebus_io.addr_o = 0;
  cachebus_io.read_o = 0;
  cachebus_io.write_o = 0;
  cachebus_io.wdata_o = 0;
end

endmodule : memory_stage
