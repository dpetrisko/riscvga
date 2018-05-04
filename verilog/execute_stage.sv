`include "rvga_types.sv"
import rvga_types::*;

module execute_stage
  ( input logic clk
    , input logic rst
    
    `ifdef INST_DEBUG_BUS
    , input rvga_opcode rfetch_execute_opcode
    , input rvga_inst_type rfetch_execute_inst_type
    , input rvga_funct3 refetch_execute_funct3
    , input rvga_funct7 refetch_execute_funct7
    `endif
    
    , input rvga_reg rfetch_execute_rs1
    , input rvga_reg rfetch_execute_rs2
    , input rvga_reg rfetch_execute_rd
    , input rvga_word rfetch_execute_imm_data
    , input logic rfetch_execute_imm_v
    , input rvga_word rfetch_execute_rs1_data
    , input rvga_word rfetch_execute_rs2_data
    , input rvga_artop rfetch_execute_artop
    , input logic rfetch_execute_alt_art
    
    `ifdef INST_DEBUG_BUS
    , output rvga_opcode execute_memory_opcode
    , output rvga_inst_type execute_memory_inst_type
    , output rvga_funct3 execute_memory_funct3
    , output rvga_funct7 execute_memory_funct7
    `endif
    
    , output rvga_reg execute_memory_rs1
    , output rvga_reg execute_memory_rs2
    , output rvga_reg execute_memory_rd
    , output rvga_reg execute_memory_result
    );

rvga_word alu_result;
rvga_word alu_srca;
rvga_word alu_srcb;

always_ff @(posedge clk) begin
  `ifdef INST_DEBUG_BUS
    execute_memory_opcode <= rfetch_execute_opcode;
    execute_memory_inst_type <= rfetch_execute_inst_type;
    execute_memory_funct3 <= rfetch_execute_funct3;
    execute_memory_funct7 <= rfetch_execute_funct7;
  `endif
  
  execute_memory_rs1 <= rfetch_execute_rs1;
  execute_memory_rs2 <= rfetch_execute_rs2;
  execute_memory_rd <= rfetch_execute_rd;
  
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
