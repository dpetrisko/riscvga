`include "rvga_types.sv"
import rvga_types::*;
import rvga_types::*;

module inst_decoder
  ( input rvga_word pc_i
    , input rvga_word ir_i
  
    , output rvga_decode_cword cword_o
    );

always_comb begin
  cword_o.pc = pc_i;
  cword_o.opcode = ir_i[6:0];
  cword_o.rs1 = ir_i[19:15];
  cword_o.rs2 = ir_i[24:20];
  cword_o.rd = ir_i[11:7];
  cword_o.funct3 = ir_i[14:12];
  cword_o.funct7 = ir_i[31:25];
  
  cword_o.br_v = '0;
  cword_o.rd_w_v = '0;
  
  case(cword_o.opcode) 
    e_rvga_opcode_br: begin
      cword_o.br_v = '1;
    end
    
    e_rvga_opcode_jal: begin
      cword_o.br_v = '1;
    end   
    
    e_rvga_opcode_jalr: begin 
      cword_o.br_v = '1;
    end 
    
    e_rvga_opcode_imm: begin
      cword_o.rd_w_v = '1;
    end
    
    default: begin

    end
  endcase
end

endmodule : inst_decoder

