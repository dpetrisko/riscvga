`include "rvga_types.sv"
import rvga_types::*;

module ifetch_stage
  ( input logic clk
    , input logic rst
    
    , output rvga_word ifetch_icache_addr
    , output logic ifetch_icache_read
    , input rvga_word icache_ifetch_rdata
    , input logic icache_ifetch_resp
    
    , output rvga_word ifetch_decode_instruction
    
    , input rvga_word writeback_ifetch_pc_target
    , input logic writeback_ifetch_pc_redirect
    );

rvga_word pc;
rvga_word instruction;

always_ff @(posedge clk) begin
  if(rst) begin
      pc <= ELF_START;
      instruction <= 0;
  end else begin
      if(icache_ifetch_resp) begin 
        pc <= pc + 4;
        instruction <= icache_ifetch_rdata;
      end
    end
end

always_comb begin
  ifetch_icache_addr = pc;
  ifetch_icache_read = 1'b1;
  ifetch_decode_instruction = instruction;
end

endmodule : ifetch_stage
