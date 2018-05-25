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

  writeback_ifetch_pc_target <= 0;
  writeback_ifetch_pc_redirect_v <= 0;
  
  writeback_rfetch_rd_w_v <= memory_writeback_rd_w_v;
  writeback_rfetch_rd <= memory_writeback_rd;
  writeback_rfetch_rd_data <= memory_writeback_result;
  
  `ifdef INST_TRACE_DEBUG
    $display("Inst: %0s Type: %0s WB: %x RD: %x Result: %x", debugbus_o.opcode.name()
                                                           , debugbus_o.inst_type.name()                                                                          
                                                           , writeback_rfetch_rd_w_v
                                                           , writeback_rfetch_rd
                                                           , writeback_rfetch_rd_data);
  `endif
end

always_comb begin

end

endmodule : writeback_stage
