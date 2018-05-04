`include "rvga_types.sv"
import rvga_types::*;

module decode_stage
  ( input logic clk
    , input logic rst
    
    , input rvga_word ifetch_decode_instruction
    
    , output rvga_opcode_e decode_rfetch_opcode
    , output rvga_inst_type_e decode_rfetch_inst_type
    , output rvga_funct3 decode_refetch_funct3
    , output rvga_funct7 decode_refetch_funct7
    
    , output rvga_reg decode_rfetch_rs1
    , output rvga_reg decode_rfetch_rs2
    , output rvga_reg decode_rfetch_rd
    , output rvga_word decode_rfetch_imm
    );

rvga_opcode_e opcode;
rvga_inst_type_e inst_type;
rvga_funct3 funct3;
rvga_funct7 funct7;
rvga_reg rs1;
rvga_reg rs2;
rvga_reg rd;
rvga_word imm;

always_ff @(posedge clk) begin
  decode_rfetch_opcode <= opcode;
  decode_rfetch_inst_type <= inst_type;
  decode_refetch_funct3 <= funct3;
  decode_refetch_funct7 <= funct7;
  decode_rfetch_rs1 <= rs1;
  decode_rfetch_rs2 <= rs2;
  decode_rfetch_rd <= rd;
  decode_rfetch_imm <= imm;
end

always_comb begin
  opcode = rvga_opcode_e'(ifetch_decode_instruction[6:0]);
    
  case(opcode) 
    e_rvga_opcode_br: begin 
        inst_type = e_rvga_inst_type_b;
    end
    
    e_rvga_opcode_imm : begin 
        inst_type = e_rvga_inst_type_i;
    end
  endcase
  
  case(inst_type)
    e_rvga_inst_type_r: imm = 0;
    e_rvga_inst_type_i: imm = {{20{ifetch_decode_instruction[31]}}, ifetch_decode_instruction[31:20]};
    e_rvga_inst_type_s: imm = {{20{ifetch_decode_instruction[31]}}, ifetch_decode_instruction[31:25], ifetch_decode_instruction[11:7]};
    e_rvga_inst_type_b: imm = {{20{ifetch_decode_instruction[31]}}, ifetch_decode_instruction[7], ifetch_decode_instruction[30:25], ifetch_decode_instruction[11:8]};
    e_rvga_inst_type_u: imm = {{12{ifetch_decode_instruction[31]}}, ifetch_decode_instruction[31:12]};
    e_rvga_inst_type_j: imm = {{12{ifetch_decode_instruction[31]}}, ifetch_decode_instruction[19:12], ifetch_decode_instruction[20], ifetch_decode_instruction[30:21]};
  endcase
  
  funct3 = rvga_funct3'(0);
  funct7 = rvga_funct7'(0);
end 

endmodule : decode_stage
