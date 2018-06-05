`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

module ifetch_stage
  ( input logic clk_i
    , input logic rst_i
    
    , rvga_cachebus_if.master cachebus_io
    
    , output rvga_word ifetch_pc
    , output rvga_word ifetch_inst
    
    , input logic decode_br_v
    , input logic decode_btarget
    
    , input rvga_word writeback_pc_target
    );

rvga_word pc_n, pc_r;
rvga_word ir_n, ir_r;
        
always_comb begin
  pc_n = decode_br_v ? decode_btarget : (pc_r + 32'h4);
  ir_n = cachebus_io.rdata_i;
  
  cachebus_io.addr_o = pc_r;
  cachebus_io.read_o = 1'b1;
  cachebus_io.write_o = '0;
  cachebus_io.wdata_o = '0;
  
  ifetch_pc = pc_r;
  ifetch_inst = ir_r;
end

always_ff @(posedge clk_i) begin
  if (rst_i) begin
    pc_r <= '0;
    ir_r <= '0;
  end else if(cachebus_io.resp_i) begin
    pc_r <= pc_n;
    ir_r <= ir_n;
  end
end

endmodule : ifetch_stage
