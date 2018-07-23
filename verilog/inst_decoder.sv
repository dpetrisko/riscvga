`include "rvga_types.sv"
import rvga_types::*;
import rvga_types::*;

module inst_decoder
  ( input rvga_word pc_i
    , input rvga_word ir_i
  
    , output rvga_rfetch_cword decoded_o
    );

rvga_inst_type inst_type;

always_comb begin
  decoded_o.v = '1;
  decoded_o.pc = pc_i;
  decoded_o.opcode = ir_i[6:0];
  decoded_o.rs1 = ir_i[19:15];
  decoded_o.rs2 = ir_i[24:20];
  decoded_o.rd = ir_i[11:7];
  decoded_o.funct3 = ir_i[14:12];
  decoded_o.funct7 = ir_i[31:25];

  decoded_o.br_v = '0;
  decoded_o.jmp_v = '0;
  decoded_o.rd_w_v = '0;
  decoded_o.imm = '0;
  decoded_o.imm_v = '0;
  decoded_o.dmem_r_v = '0;
  decoded_o.dmem_w_v = '0;
  decoded_o.addpc_v = '0;
  
  case (decoded_o.opcode) 
    e_rvga_opcode_auipc: begin
      inst_type = e_rvga_inst_type_u;
      decoded_o.imm_v = '1;
      decoded_o.addpc_v = '1;
      decoded_o.rd_w_v = '1;
    end
    
    e_rvga_opcode_lui: begin
      inst_type = e_rvga_inst_type_u;
      decoded_o.funct3 = e_rvga_artop_addsub;
      decoded_o.funct7 = '0;
      decoded_o.rs1 = '0;
      decoded_o.imm_v = '1;
      decoded_o.rd_w_v = '1;
    end
   
    e_rvga_opcode_jal: begin
      inst_type = e_rvga_inst_type_j;
      decoded_o.addpc_v = '1;
      decoded_o.imm_v = '1;
      decoded_o.jmp_v = '1;
      decoded_o.rd_w_v = '1;
    end   
    
    e_rvga_opcode_jalr: begin 
      inst_type = e_rvga_inst_type_i;
      decoded_o.funct3 = e_rvga_artop_addsub;
      decoded_o.funct7 = '0;
      decoded_o.imm_v = '1;
      decoded_o.jmp_v = '1;
      decoded_o.rd_w_v = '1;
    end 
    
    e_rvga_opcode_imm: begin
      inst_type = e_rvga_inst_type_i;
      decoded_o.funct7 = '0;
      decoded_o.imm_v = '1;
      decoded_o.rd_w_v = '1;
    end
    
    e_rvga_opcode_reg: begin
      inst_type = e_rvga_inst_type_r;
      decoded_o.rd_w_v = '1;
    end
    
    e_rvga_opcode_ld: begin
      inst_type = e_rvga_inst_type_i;
      decoded_o.imm_v = '1;
      decoded_o.dmem_r_v = '1;
      decoded_o.rd_w_v = '1;
    end
    
    e_rvga_opcode_st: begin
      inst_type = e_rvga_inst_type_s;
      decoded_o.imm_v = '1;
      decoded_o.dmem_w_v = '1;
    end
    
    default: begin
      inst_type = e_rvga_inst_type_e;
    end
  endcase
  
  case(inst_type)
    e_rvga_inst_type_i: if((decoded_o.funct3 == e_rvga_artop_sll) || decoded_o.funct3 == e_rvga_artop_srx) begin
                            decoded_o.imm = {27'b0, ir_i[24:20]};
                        end else begin
                            decoded_o.imm = {{20{ir_i[31]}}, ir_i[31:20]};
                        end
    e_rvga_inst_type_s: decoded_o.imm = {{20{ir_i[31]}}, ir_i[31:25], ir_i[11:7]};
    e_rvga_inst_type_b: decoded_o.imm = {{19{ir_i[31]}}, ir_i[7], ir_i[30:25], ir_i[11:8], 1'b0};
    e_rvga_inst_type_u: decoded_o.imm = {ir_i[31:12], {12{1'b0}}};
    e_rvga_inst_type_j: decoded_o.imm = {{11{ir_i[31]}}, ir_i[19:12], ir_i[20], ir_i[30:21], 1'b0};
    default: decoded_o.imm = 0;
  endcase

end

endmodule : inst_decoder

