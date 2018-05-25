`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

module execute_stage
  ( input logic clk
    , input logic rst
    
    , input rvga_reg rfetch_execute_rs1
    , input rvga_reg rfetch_execute_rs2
    , input rvga_reg rfetch_execute_rd
    , input logic rfetch_execute_rd_w_v
    , input rvga_word rfetch_execute_imm_data
    , input logic rfetch_execute_imm_v
    , input rvga_word rfetch_execute_rs1_data
    , input rvga_word rfetch_execute_rs2_data
    , input rvga_artop_e rfetch_execute_artop
    , input logic rfetch_execute_alt_art

    , output rvga_reg execute_memory_rs1
    , output rvga_reg execute_memory_rs2
    , output rvga_reg execute_memory_rd
    , output logic execute_memory_rd_w_v
    , output rvga_word execute_memory_result
    
    `ifdef INST_DEBUG_BUS
    , rvga_debugbus_if.i debugbus_i
    , rvga_debugbus_if.o debugbus_o
    `endif
    );

rvga_word alu_result;
rvga_word alu_srca;
rvga_word alu_srcb;

always_ff @(posedge clk) begin
  `ifdef INST_DEBUG_BUS
    debugbus_o.opcode <= debugbus_i.opcode;
    debugbus_o.inst_type <= debugbus_i.inst_type;  
    debugbus_o.brop <= debugbus_i.brop;
    debugbus_o.ldop <= debugbus_i.ldop;
    debugbus_o.strop <= debugbus_i.strop;
    debugbus_o.artop <= debugbus_i.artop;
  `endif
  
  execute_memory_rs1 <= rfetch_execute_rs1;
  execute_memory_rs2 <= rfetch_execute_rs2;
  execute_memory_rd <= rfetch_execute_rd;
  execute_memory_rd_w_v <= rfetch_execute_rd_w_v;
  execute_memory_result <= alu_result;
end

always_comb begin
  alu_srca = rfetch_execute_rs1_data;
  alu_srcb = rfetch_execute_imm_v ? rfetch_execute_imm_data : rfetch_execute_rs2_data;
end

alu #(
      )
 alu (.op(rfetch_execute_artop)
      ,.a(alu_srca)
      ,.b(alu_srcb)
      ,.alt(rfetch_execute_alt_art)
      
      ,.o(alu_result)
      );

endmodule : execute_stage
