`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

module ifetch_stage
  ( input logic clk
    , input logic rst
    
    , rvga_cachebus_if.master cachebus_io
    
    , output rvga_word ifetch_decode_pc
    , output rvga_word ifetch_decode_instruction
    
    , input rvga_word writeback_ifetch_pc_target
    , input logic writeback_ifetch_pc_w_v
    );

rvga_word pc;
rvga_word instruction;

always_ff @(posedge clk) begin
  if(rst) begin
      pc <= ELF_START;
      instruction <= 0;
  end else begin
      if(cachebus_io.resp_i) begin 
        pc <= pc + 4;
        instruction <= cachebus_io.rdata_i;
      end
    end
end

always_comb begin
  cachebus_io.addr_o = pc;
  cachebus_io.read_o = 1'b1;
  cachebus_io.write_o = 1'b0;
  cachebus_io.wdata_o = 32'b0;
  ifetch_decode_instruction = instruction;
  ifetch_decode_pc = pc;
end

endmodule : ifetch_stage
