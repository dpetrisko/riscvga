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
    
    , input rvga_word writeback_pc_target
    );

rvga_word pc_n, pc_r;
rvga_word ir_n, ir_r;

  dff #(.width($bits(rvga_word))
        )
    pc (.clk_i(clk_i)
        ,.rst_i(rst_i)
        ,.w_v_i(cachebus_io.resp_i)
        ,.data_i(pc_n)
        ,.data_o(pc_r)
        );
        
  dff #(.width($bits(rvga_word))
        )
    ir (.clk_i(clk_i)
        ,.rst_i(rst_i)
        ,.w_v_i(cachebus_io.resp_i)
        ,.data_i(ir_n)
        ,.data_o(ir_r)
        );
        
always_comb begin
  pc_n = pc_r + 32'h4;
  ir_n = cachebus_io.rdata_i;
  
  cachebus_io.addr_o = pc_r;
  cachebus_io.read_o = 1'b1;
  
  ifetch_pc = pc_r;
  ifetch_inst = ir_r;
end

endmodule : ifetch_stage
