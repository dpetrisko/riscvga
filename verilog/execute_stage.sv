`include "rvga_types.sv"
import rvga_types::*;

module execute_stage
  ( input logic clk
    , input logic rst
    
    , input rvga_opcode_e rfetch_execute_opcode
    , input rvga_inst_type_e rfetch_execute_inst_type
    , input rvga_funct3 refetch_execute_funct3
    , input rvga_funct7 refetch_execute_funct7
    , input rvga_reg rfetch_execute_rs1
    , input rvga_reg rfetch_execute_rs2
    , input rvga_reg rfetch_execute_rd
    , input rvga_word rfetch_execute_imm
    , input rvga_word rfetch_execute_rs1_data
    , input rvga_word rfetch_execute_rs2_data
    
    , output rvga_opcode_e execute_memory_opcode
    , output rvga_inst_type_e execute_memory_inst_type
    , output rvga_funct3 execute_memory_funct3
    , output rvga_funct7 execute_memory_funct7
    
    , output rvga_reg execute_memory_rs1
    , output rvga_reg execute_memory_rs2
    , output rvga_reg execute_memory_rd
    , output rvga_word execute_memory_rd_data
    );

rvga_word alu_result;

always_ff @(posedge clk) begin
    
end

always_comb begin
  alu_result = 0;
    
  //case(refetch_execute_funct3)
    
  //endcase
end

endmodule : execute_stage
