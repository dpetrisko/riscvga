`include "rvga_types.sv"
import rvga_types::*;

module decode_stage
  ( input logic clk
    , input logic rst
    
    , input rvga_word ifetch_decode_instruction
    
    `ifdef INST_DEBUG_BUS
    , output rvga_opcode decode_rfetch_opcode
    , output rvga_inst_type decode_rfetch_inst_type
    , output rvga_funct3 decode_refetch_funct3
    , output rvga_funct7 decode_refetch_funct7
    `endif
    
    , output rvga_reg decode_rfetch_rs1
    , output rvga_reg decode_rfetch_rs2
    , output rvga_reg decode_rfetch_rd
    , output rvga_word decode_rfetch_imm_data
    , output logic decode_rfetch_imm_v
    , output rvga_artop decode_rfetch_artop 
    , output logic decode_rfetch_alt_art
    );

rvga_opcode_e opcode;
rvga_inst_type_e inst_type;
rvga_funct3 funct3;
rvga_funct7 funct7;
rvga_reg rs1;
rvga_reg rs2;
rvga_reg rd;
rvga_word imm;
logic imm_v;
logic alt_art;

always_ff @(posedge clk) begin
  `ifdef INST_DEBUG_BUS
    decode_rfetch_opcode <= opcode;
    decode_rfetch_inst_type <= inst_type;
    decode_refetch_funct3 <= funct3;
    decode_refetch_funct7 <= funct7;
  `endif
  decode_rfetch_rs1 <= rs1;
  decode_rfetch_rs2 <= rs2;
  decode_rfetch_rd <= rd;
  decode_rfetch_imm_data <= imm;
  decode_rfetch_artop <= funct3;
  decode_rfetch_imm_v <= imm_v; 
  decode_rfetch_alt_art <= alt_art;
end

always_comb begin
  funct7 = ifetch_decode_instruction[31:25];
  rs2 = ifetch_decode_instruction[24:20];
  rs1 = ifetch_decode_instruction[19:15];
  funct3 = ifetch_decode_instruction[14:12];
  rd = ifetch_decode_instruction[11:7];
  opcode = rvga_opcode_e'(ifetch_decode_instruction[6:0]);
  
  alt_art = 1'b0;
  imm_v = 1'b0;
    
  case(opcode) 
    e_rvga_opcode_br: begin 
      inst_type = e_rvga_inst_type_b;
    end
    
    e_rvga_opcode_imm : begin 
      inst_type = e_rvga_inst_type_i;
      imm_v = 1'b1;
      alt_art = ifetch_decode_instruction[30];
    end
    
    default: inst_type = e_rvga_inst_type_e;
  endcase
  
  case(inst_type)
    e_rvga_inst_type_i: if((funct3 == e_rvga_artop_sll) || funct3 == e_rvga_artop_srx) begin
                            imm = {27'b0, ifetch_decode_instruction[24:20]};
                        end else begin
                            imm = {{20{ifetch_decode_instruction[31]}}, ifetch_decode_instruction[31:20]};
                        end
    e_rvga_inst_type_s: imm = {{20{ifetch_decode_instruction[31]}}, ifetch_decode_instruction[31:25], ifetch_decode_instruction[11:7]};
    e_rvga_inst_type_b: imm = {{20{ifetch_decode_instruction[31]}}, ifetch_decode_instruction[7], ifetch_decode_instruction[30:25], ifetch_decode_instruction[11:8]};
    e_rvga_inst_type_u: imm = {{12{ifetch_decode_instruction[31]}}, ifetch_decode_instruction[31:12]};
    e_rvga_inst_type_j: imm = {{12{ifetch_decode_instruction[31]}}, ifetch_decode_instruction[19:12], ifetch_decode_instruction[20], ifetch_decode_instruction[30:21]};
    default: imm = 0;
  endcase
end 

endmodule : decode_stage
