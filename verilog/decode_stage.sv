`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

module decode_stage
  ( input logic clk_i
    , input logic rst_i
    
    , input rvga_word ifetch_pc
    , input rvga_word ifetch_inst
    
    , output rvga_word decode_pc
    , output rvga_reg decode_rs1
    , output rvga_reg decode_rs2
    , output rvga_reg decode_rd
    , output rvga_word decode_imm_data
    
    , output rvga_cword_s cword_o
  
    , output rvga_dword_s dword_o
    );

rvga_opcode_e opcode;
rvga_inst_type_e inst_type;
logic[2:0] funct3;
logic[6:0] funct7;
rvga_reg rs1;
rvga_reg rs2;
rvga_reg rd;
rvga_word imm;
logic imm_v;
logic alt_art;
logic rd_w_v;
logic dcache_w_v;
logic dcache_r_v;
logic imm_passthrough_v;
logic rs1_pc_sel;

rvga_dword_s dword;

always_ff @(posedge clk_i) begin
  if (rst_i) begin
    decode_pc <= '0;
    decode_rs1 <= '0;
    decode_rs2 <= '0;
    decode_rd <= '0;
    decode_imm_data <= '0;
    cword_o <= '0;
    dword_o <= '0;
  end else begin
    decode_pc <= ifetch_pc;
    decode_rs1 <= rs1;
    decode_rs2 <= rs2;
    decode_rd <= rd;
    decode_imm_data <= imm;
    cword_o.rd_w_v <= rd_w_v;
    cword_o.dcache_w_v <= dcache_w_v;
    cword_o.dcache_r_v <= dcache_r_v;
    cword_o.funct3 <= funct3;
    cword_o.imm_v <= imm_v; 
    cword_o.rs1_pc_sel <= rs1_pc_sel;
    cword_o.imm_passthrough_v <= imm_passthrough_v;
    cword_o.alt_art <= alt_art;
    dword_o.opcode <= opcode;
    dword_o.inst_type <= inst_type;
  end
end

always_comb begin
  funct7 = ifetch_inst[31:25];
  rs2 = ifetch_inst[24:20];
  rs1 = ifetch_inst[19:15];
  funct3 = ifetch_inst[14:12];
  rd = ifetch_inst[11:7];
  opcode = rvga_opcode_e'(ifetch_inst[6:0]);
  
  alt_art = 1'b0;
  imm_v = 1'b0;
  rd_w_v = 1'b0;
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
      funct3 = e_rvga_artop_addsub;
      rs1_pc_sel = 1'b1;
    end
    
    e_rvga_opcode_reg : begin
      inst_type = e_rvga_inst_type_r;
      
      case(funct3)
        e_rvga_artop_srx: alt_art = ifetch_inst[30];
        e_rvga_artop_addsub: alt_art = ifetch_inst[30];
      endcase
      
      rd_w_v = 1'b1;
    end
    
    e_rvga_opcode_imm : begin 
      inst_type = e_rvga_inst_type_i;
      imm_v = 1'b1;
      
      case(funct3)
        e_rvga_artop_srx: alt_art = ifetch_inst[30];
      endcase

      rd_w_v = 1'b1;
    end
    
    e_rvga_opcode_st: begin
      inst_type = e_rvga_inst_type_s;
      imm_v = 1'b1;
      
      dcache_w_v = 1'b1;
    end
    
    e_rvga_opcode_ld: begin
      inst_type = e_rvga_inst_type_i;
      imm_v = 1'b1;
      
      dcache_r_v = 1'b1;
      rd_w_v = 1'b1;
    end
    
    default: inst_type = e_rvga_inst_type_e;
  endcase
  
  case(inst_type)
    e_rvga_inst_type_i: if((funct3 == e_rvga_artop_sll) || funct3 == e_rvga_artop_srx) begin
                            imm = {27'b0, ifetch_inst[24:20]};
                        end else begin
                            imm = {{20{ifetch_inst[31]}}, ifetch_inst[31:20]};
                        end
    e_rvga_inst_type_s: imm = {{20{ifetch_inst[31]}}, ifetch_inst[31:25], ifetch_inst[11:7]};
    e_rvga_inst_type_b: imm = {{20{ifetch_inst[31]}}, ifetch_inst[7], ifetch_inst[30:25], ifetch_inst[11:8]};
    e_rvga_inst_type_u: imm = {ifetch_inst[31:12], {12{1'b0}}};
    e_rvga_inst_type_j: imm = {{12{ifetch_inst[31]}}, ifetch_inst[19:12], ifetch_inst[20], ifetch_inst[30:21]};
    default: imm = 0;
  endcase
end 

endmodule : decode_stage
