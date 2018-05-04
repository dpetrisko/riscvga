`include "rvga_types.sv"
import rvga_types::*;

module memory_stage
  ( input logic clk
    , input logic rst
    
    `ifdef INST_DEBUG_BUS
    , input rvga_opcode execute_memory_opcode
    , input rvga_inst_type execute_memory_inst_type
    , input rvga_funct3 execute_memory_funct3
    , input rvga_funct7 execute_memory_funct7
    `endif
    
    `ifdef INST_DEBUG_BUS
    , output rvga_opcode memory_writeback_opcode
    , output rvga_inst_type memory_writeback_inst_type
    , output rvga_funct3 memory_writeback_funct3
    , output rvga_funct7 memory_writeback_funct7
    `endif
    
    , output rvga_word memory_dcache_addr
    , output logic memory_dcache_read
    , input rvga_word dcache_memory_rdata
    , output logic memory_dcache_write
    , output rvga_word memory_dcache_wdata
    , input logic dcache_memory_resp
    );

always_ff @(posedge clk) begin
  `ifdef INST_DEBUG_BUS
  memory_writeback_opcode <= execute_memory_opcode;
  memory_writeback_inst_type <= execute_memory_inst_type;
  memory_writeback_funct3 <= execute_memory_funct3;
  memory_writeback_funct7 <= execute_memory_funct7;
  `endif
end

always_comb begin
  memory_dcache_addr = 0;
  memory_dcache_read = 0;
  memory_dcache_write = 0;
  memory_dcache_wdata = 0;
end

endmodule : memory_stage
