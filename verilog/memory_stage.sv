`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

module memory_stage
  ( input logic clk
    , input logic rst
    
    , input rvga_reg execute_memory_rd
    , input rvga_word execute_memory_result
    , input rvga_word execute_memory_data
    , rvga_cword_if.i cword_i
    
    , output rvga_reg memory_writeback_rd
    , output rvga_word memory_writeback_result
    , rvga_cword_if.o cword_o
    
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
  
  memory_writeback_rd <= execute_memory_rd;
  memory_writeback_result <= cword_i.dcache_r_v ? cachebus_io.rdata_i : execute_memory_result;
  
  cword_o.rd_w_v <= cword_i.rd_w_v;
  cword_o.pc_w_v <= cword_i.pc_w_v;
  cword_o.artop <= cword_i.artop;
  cword_o.brop <= cword_i.brop;
  cword_o.ldop <= cword_i.ldop;
  cword_o.strop <= cword_i.strop;
  cword_o.imm_v <= cword_i.imm_v; 
  cword_o.dcache_r_v <= cword_i.dcache_r_v;
  cword_o.dcache_w_v <= cword_i.dcache_w_v;
  cword_o.rs1_pc_sel <= cword_i.rs1_pc_sel;
  cword_o.imm_passthrough_v <= cword_i.imm_passthrough_v;
  cword_o.alt_art <= cword_i.alt_art;
end

always_comb begin
  cachebus_io.addr_o = execute_memory_result;
  cachebus_io.read_o = cword_i.dcache_r_v;
  cachebus_io.write_o = cword_i.dcache_w_v;
  cachebus_io.wdata_o = execute_memory_data;
end

endmodule : memory_stage
