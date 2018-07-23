module rvga_nonsynth_monitor
  ( input logic clk_i
    , input logic debug_word_v_i
    , input rvga_writeback_cword debug_word_i
  );
  
task print_imm(input rvga_writeback_cword debug_word);
  case(debug_word.funct3) 
    e_rvga_artop_addsub : if(debug_word.funct7 == 0) begin
                            $display("@PC %x, COMMITTED ADDIMM: R%d (%x) = R%d (%x) + IMM (%x)\n",
                                     debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.rs1, debug_word.rs1_data, debug_word.imm);  
                          end else begin
                            $display("@PC %x, COMMITTED SUBIMM: R%d (%x) = R%d (%x) - IMM (%x)\n",
                                     debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.rs1, debug_word.rs1_data, debug_word.imm);               
                          end
    e_rvga_artop_sll    : $display("@PC %x, COMMITTED SLLIMM: R%d (%x) = R%d (%x) << IMM (%x)\n",
                                   debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.rs1, debug_word.rs1_data, debug_word.imm);  
    e_rvga_artop_slt    : $display("@PC %x, COMMITTED SLTIMM: R%d (%x) = R%d (%x) < IMM (%x)\n",
                                   debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.rs1, debug_word.rs1_data, debug_word.imm);  
    e_rvga_artop_sltu   : $display("@PC %x, COMMITTED SLTUIMM: R%d (%x) = R%d (%x) < IMM (%x)\n",
                                   debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.rs1, debug_word.rs1_data, debug_word.imm);  
    e_rvga_artop_xor    : $display("@PC %x, COMMITTED XORIMM: R%d (%x) = R%d (%x) ^ IMM (%x)\n",
                                   debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.rs1, debug_word.rs1_data, debug_word.imm);  
    e_rvga_artop_srx    : if(debug_word.funct7 == 0) begin
                            $display("@PC %x, COMMITTED SRAIMM: R%d (%x) = R%d (%x) >a IMM (%x)\n",
                                     debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.rs1, debug_word.rs1_data, debug_word.imm);  
                          end else begin
                            $display("@PC %x, COMMITTED SRLIMM: R%d (%x) = R%d (%x) > IMM (%x)\n",
                                     debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.rs1, debug_word.rs1_data, debug_word.imm);               
                          end
    e_rvga_artop_or     : $display("@PC %x, COMMITTED ORIMM: R%d (%x) = R%d (%x) | IMM (%x)\n",
                                   debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.rs1, debug_word.rs1_data, debug_word.imm); 
    e_rvga_artop_and    : $display("@PC %x, COMMITTED ANDIMM: R%d (%x) = R%d (%x) & IMM (%x)\n",
                                   debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.rs1, debug_word.rs1_data, debug_word.imm); 
  endcase
endtask

task print_reg(input rvga_writeback_cword debug_word);
  case(debug_word.funct3) 
    e_rvga_artop_addsub : if(debug_word.funct7 == 0) begin
                            $display("@PC %x, COMMITTED ADD: R%d (%x) = R%d (%x) + R%d (%x)\n",
                                     debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.rs1, debug_word.rs1_data, debug_word.rs2, debug_word.rs2_data);  
                          end else begin
                            $display("@PC %x, COMMITTED SUB: R%d (%x) = R%d (%x) - R%d (%x)\n",
                                     debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.rs1, debug_word.rs1_data, debug_word.rs2, debug_word.rs2_data);               
                          end
    e_rvga_artop_sll    : $display("@PC %x, COMMITTED SLL: R%d (%x) = R%d (%x) << R%d (%x)\n",
                                   debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.rs1, debug_word.rs1_data, debug_word.rs2, debug_word.rs2_data);  
    e_rvga_artop_slt    : $display("@PC %x, COMMITTED SLT: R%d (%x) = R%d (%x) < R%d (%x)\n",
                                   debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.rs1, debug_word.rs1_data, debug_word.rs2, debug_word.rs2_data);  
    e_rvga_artop_sltu   : $display("@PC %x, COMMITTED SLTU: R%d (%x) = R%d (%x) < R%d (%x)\n",
                                   debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.rs1, debug_word.rs1_data, debug_word.rs2, debug_word.rs2_data);  
    e_rvga_artop_xor    : $display("@PC %x, COMMITTED XOR: R%d (%x) = R%d (%x) ^ R%d (%x)\n",
                                   debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.rs1, debug_word.rs1_data, debug_word.rs2, debug_word.rs2_data);  
    e_rvga_artop_srx    : if(debug_word.funct7 == 0) begin
                            $display("@PC %x, COMMITTED SRA: R%d (%x) = R%d (%x) >a R%d (%x)\n",
                                     debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.rs1, debug_word.rs1_data, debug_word.rs2, debug_word.rs2_data);  
                          end else begin
                            $display("@PC %x, COMMITTED SRL: R%d (%x) = R%d (%x) > R%d (%x)\n",
                                     debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.rs1, debug_word.rs1_data, debug_word.rs2, debug_word.rs2_data);               
                          end
    e_rvga_artop_or     : $display("@PC %x, COMMITTED OR: R%d (%x) = R%d (%x) | R%d (%x)\n",
                                   debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.rs1, debug_word.rs1_data, debug_word.rs2, debug_word.rs2_data); 
    e_rvga_artop_and    : $display("@PC %x, COMMITTED AND: R%d (%x) = R%d (%x) & R%d (%x)\n",
                                   debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.rs1, debug_word.rs1_data, debug_word.rs2, debug_word.rs2_data); 
  endcase
endtask

task print_lui(input rvga_writeback_cword debug_word);
  $display("@PC %x, COMMITTED LUI: R%d (%x) = IMM (%x) (%x << 12)\n",
           debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.imm, debug_word >> 12);
endtask

task print_auipc(input rvga_writeback_cword debug_word);
  $display("@PC %x, COMMITTED AUIPC: R%d (%x) = PC (%x) + IMM (%x) (%x << 12)\n",
           debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.pc, debug_word.imm, debug_word >> 12);
endtask

task print_jal(input rvga_writeback_cword debug_word);
  $display("@PC %x, COMMITTED JAL: PC (%x) = PC (%x) + IMM (%x); R%x (%x) = PC (%x) + 4\n",
           debug_word.pc, debug_word.br_tgt, debug_word.pc, debug_word.imm, debug_word.rd, debug_word.rd_data, debug_word.pc);
endtask

task print_jalr(input rvga_writeback_cword debug_word);
  $display("@PC %x, COMMITTED JALR: PC (%x) = R%x (%x) + IMM (%x); R%x (%x) = PC (%x) + 4\n",
           debug_word.pc, debug_word.br_tgt, debug_word.rs1, debug_word.rs1_data, debug_word.imm, debug_word.rd, debug_word.rd_data, debug_word.pc);
endtask

task print_br(input rvga_writeback_cword debug_word);
  case(debug_word.funct3) 
    e_rvga_brop_beq  : $display("@PC %x, COMMITTED BEQ: if (R%x (%x) == R%x (%x)) PC (%x) = PC (%x) + IMM (%x)\n",
                                debug_word.pc, debug_word.rs1, debug_word.rs1_data, debug_word.rs2, debug_word.rs2_data, debug_word.br_tgt, debug_word.pc, debug_word.imm);
    e_rvga_brop_bne  : $display("@PC %x, COMMITTED BNE: if (R%x (%x) != R%x (%x)) PC (%x) = PC (%x) + IMM (%x)\n",
                                debug_word.pc, debug_word.rs1, debug_word.rs1_data, debug_word.rs2, debug_word.rs2_data, debug_word.br_tgt, debug_word.pc, debug_word.imm);
    e_rvga_brop_blt  : $display("@PC %x, COMMITTED BLT: if (R%x (%x) < R%x (%x)) PC (%x) = PC (%x) + IMM (%x)\n",
                                debug_word.pc, debug_word.rs1, debug_word.rs1_data, debug_word.rs2, debug_word.rs2_data, debug_word.br_tgt, debug_word.pc, debug_word.imm);
    e_rvga_brop_bge  : $display("@PC %x, COMMITTED BGE: if (R%x (%x) > R%x (%x)) PC (%x) = PC (%x) + IMM (%x)\n",
                                debug_word.pc, debug_word.rs1, debug_word.rs1_data, debug_word.rs2, debug_word.rs2_data, debug_word.br_tgt, debug_word.pc, debug_word.imm);
    e_rvga_brop_bltu : $display("@PC %x, COMMITTED BLTU: if (R%x (%x) == R%x (%x)) PC (%x) = PC (%x) + IMM (%x)\n",
                                debug_word.pc, debug_word.rs1, debug_word.rs1_data, debug_word.rs2, debug_word.rs2_data, debug_word.br_tgt, debug_word.pc, debug_word.imm);
    e_rvga_brop_bgeu : $display("@PC %x, COMMITTED BGEU: if (R%x (%x) == R%x (%x)) PC (%x) = PC (%x) + IMM (%x)\n",
                                debug_word.pc, debug_word.rs1, debug_word.rs1_data, debug_word.rs2, debug_word.rs2_data, debug_word.br_tgt, debug_word.pc, debug_word.imm);
  endcase
endtask

task print_ld(rvga_writeback_cword debug_word);
  case(debug_word.funct3)
    e_rvga_ldop_lb  : $display("@PC %x, COMMITTED LB: R%x (%x) = BYTE(MEM[%x]) (%x)\n",
                               debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.alu_result, debug_word.ld_result);
    e_rvga_ldop_lh  : $display("@PC %x, COMMITTED LH: R%x (%x) = HALF(MEM[%x]) (%x)\n",
                               debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.alu_result, debug_word.ld_result);
    e_rvga_ldop_lw  : $display("@PC %x, COMMITTED LW: R%x (%x) = MEM[%x] (%x)\n",
                               debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.alu_result, debug_word.ld_result);
    e_rvga_ldop_lbu : $display("@PC %x, COMMITTED LBU: R%x (%x) = UBYTE(MEM[%x]) (%x)\n",
                               debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.alu_result, debug_word.ld_result);
    e_rvga_ldop_lhu : $display("@PC %x, COMMITTED LHU: R%x (%x) = UHALF (MEM[%x]) (%x)\n",
                               debug_word.pc, debug_word.rd, debug_word.rd_data, debug_word.alu_result, debug_word.ld_result);
  endcase
endtask

task print_st(rvga_writeback_cword debug_word);
  case(debug_word.funct3)
    e_rvga_strop_sb  : $display("@PC %x, COMMITTED SB: MEM[(R%x (%x) + IMM (%x)) (%x)] = BYTE(R%x (%x))\n",
                               debug_word.pc, debug_word.rs1, debug_word.rs1_data, debug_word.imm, debug_word.alu_result, debug_word.rs2, debug_word.rs2_data);
    e_rvga_strop_sh  : $display("@PC %x, COMMITTED SB: MEM[(R%x (%x) + IMM (%x)) (%x)] = HALF(R%x (%x))\n",
                                debug_word.pc, debug_word.rs1, debug_word.rs1_data, debug_word.imm, debug_word.alu_result, debug_word.rs2, debug_word.rs2_data);
    e_rvga_strop_sw  : $display("@PC %x, COMMITTED SB: MEM[(R%x (%x) + IMM (%x)) (%x)] = R%x (%x)\n",
                                debug_word.pc, debug_word.rs1, debug_word.rs1_data, debug_word.imm, debug_word.alu_result, debug_word.rs2, debug_word.rs2_data);
  endcase
endtask

  
always_ff @(posedge clk_i) begin
  if(debug_word_v_i) begin
    case(debug_word_i.opcode) 
      e_rvga_opcode_lui   : $print_lui(debug_word_i);
      e_rvga_opcode_auipc : $print_auipc(debug_word_i);
      e_rvga_opcode_jal   : $print_jal(debug_word_i);
      e_rvga_opcode_jalr  : $print_jalr(debug_word_i);
      e_rvga_opcode_br    : $print_br(debug_word_i);
      e_rvga_opcode_ld    : $print_ld(debug_word_i);
      e_rvga_opcode_st    : $print_st(debug_word_i);
      e_rvga_opcode_imm   : $print_imm(debug_word_i);
      e_rvga_opcode_reg   : $print_reg(debug_word_i);
      e_rvga_opcode_fence : $display("@PC %x, ERROR: FENCE not implemented!\n", debug_word_i.pc);
      e_rvga_opcode_misc  : $display("@PC %x, ERROR: MISC not implemented!\n", debug_word_i.pc);
    endcase
  end
end
  
endmodule : rvga_nonsynth_monitor
