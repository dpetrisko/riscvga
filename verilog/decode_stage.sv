`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

module decode_stage
  ( input logic clk
    , input logic rst
    
    , input rvga_word ifetch_decode_pc
    , input rvga_word ifetch_decode_instruction
    
    , output rvga_word decode_rfetch_pc
    , output rvga_reg decode_rfetch_rs1
    , output rvga_reg decode_rfetch_rs2
    , output rvga_reg decode_rfetch_rd
    , output rvga_word decode_rfetch_imm_data
    
    , rvga_cword_if.o cword_o
    
    `ifdef INST_DEBUG_BUS
    , rvga_debugbus_if.o debugbus_o
    `endif
    );

rvga_opcode_e opcode;
rvga_inst_type_e inst_type;
rvga_artop_e artop;
rvga_brop_e brop;
rvga_ldop_e ldop;
rvga_strop_e strop;
logic[2:0] funct3;
logic[6:0] funct7;
rvga_reg rs1;
rvga_reg rs2;
rvga_reg rd;
rvga_word imm;
logic imm_v;
logic alt_art;
logic rd_w_v;
logic pc_w_v;
logic dcache_w_v;
logic dcache_r_v;
logic imm_passthrough_v;
logic rs1_pc_sel;

always_ff @(posedge clk) begin
  `ifdef INST_DEBUG_BUS
    debugbus_o.opcode <= opcode;
    debugbus_o.inst_type <= inst_type;
    debugbus_o.brop <= rvga_brop_e'(funct3);
    debugbus_o.ldop <= rvga_ldop_e'(funct3);
    debugbus_o.strop <= rvga_strop_e'(funct3);
    debugbus_o.artop <= rvga_artop_e'(funct3);
  `endif
  
  decode_rfetch_pc <= ifetch_decode_pc;
  decode_rfetch_rs1 <= rs1;
  decode_rfetch_rs2 <= rs2;
  decode_rfetch_rd <= rd;
  decode_rfetch_imm_data <= imm;
  cword_o.rd_w_v <= rd_w_v;
  cword_o.pc_w_v <= pc_w_v;
  cword_o.dcache_w_v <= dcache_w_v;
  cword_o.dcache_r_v <= dcache_r_v;
  cword_o.artop <= artop;
  cword_o.brop <= brop;
  cword_o.ldop <= ldop;
  cword_o.strop <= strop;
  cword_o.imm_v <= imm_v; 
  cword_o.rs1_pc_sel <= rs1_pc_sel;
  cword_o.imm_passthrough_v <= imm_passthrough_v;
  cword_o.alt_art <= alt_art;
end

always_comb begin
  funct7 = ifetch_decode_instruction[31:25];
  rs2 = ifetch_decode_instruction[24:20];
  rs1 = ifetch_decode_instruction[19:15];
  funct3 = ifetch_decode_instruction[14:12];
  rd = ifetch_decode_instruction[11:7];
  opcode = rvga_opcode_e'(ifetch_decode_instruction[6:0]);
  artop = e_rvga_artop_addsub;
  brop = e_rvga_brop_beq;
  ldop = e_rvga_ldop_lb;
  strop = e_rvga_strop_sb;
  
  alt_art = 1'b0;
  imm_v = 1'b0;
  rd_w_v = 1'b0;
  pc_w_v = 1'b0;
  dcache_w_v = 1'b0;
  dcache_r_v = 1'b0;
  imm_passthrough_v = 1'b0;
  rs1_pc_sel = 1'b0;
    
  case(opcode) 
    e_rvga_opcode_br: begin 
      inst_type = e_rvga_inst_type_b;
    end
    
    e_rvga_opcode_lui: begin
      inst_type = e_rvga_inst_type_u;
      imm_v = 1'b1;
      rd_w_v = 1'b1;
      imm_passthrough_v = 1'b1;
    end
    
    e_rvga_opcode_auipc: begin
      inst_type = e_rvga_inst_type_u;
      imm_v = 1'b1;
      rd_w_v = 1'b1;
      rs1_pc_sel = 1'b1;
    end
    
    e_rvga_opcode_imm : begin 
      inst_type = e_rvga_inst_type_i;
      imm_v = 1'b1;
      
      case(funct3)
        e_rvga_artop_srx: alt_art = ifetch_decode_instruction[30];
      endcase

      artop = rvga_artop_e'(funct3);
      rd_w_v = 1'b1;
    end
    
    e_rvga_opcode_st: begin
      inst_type = e_rvga_inst_type_s;
      imm_v = 1'b1;
      
      strop = rvga_strop_e'(funct3);
      dcache_w_v = 1'b1;
    end
    
    e_rvga_opcode_ld: begin
      inst_type = e_rvga_inst_type_i;
      imm_v = 1'b1;
      
      ldop = rvga_ldop_e'(funct3);
      dcache_r_v = 1'b1;
      rd_w_v = 1'b1;
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
    e_rvga_inst_type_u: imm = {ifetch_decode_instruction[31:12], {12{1'b0}}};
    e_rvga_inst_type_j: imm = {{12{ifetch_decode_instruction[31]}}, ifetch_decode_instruction[19:12], ifetch_decode_instruction[20], ifetch_decode_instruction[30:21]};
    default: imm = 0;
  endcase
end 

endmodule : decode_stage
