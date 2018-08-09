import rvga_types::*;

module rvga_nonsynth_commit_monitor #(parameter enable_p = 0)
  ( input integer cycle_i
    , input logic clk_i
    , input rvga_cword cword_i
    , input rvga_dword dword_i
  );

task solve_halting_problem(input rvga_cword cword, input rvga_dword dword);
  if(cword.opcode == e_rvga_opcode_jal) begin
    if(dword.imm_data == 0) begin
      $display("Cycle %d: HALT found", cycle_i);
      $finish();
    end
  end
endtask
  
task print_imm(input rvga_cword cword, input rvga_dword dword);
  case(cword.funct3) 
    e_rvga_artop_addsub : if(cword.funct7 == 0) begin
                            $display("Cycle %d: COMMITTED @PC %x ADDIMM: R%d (%x) = R%d (%x) + IMM (%x)",
                                     cycle_i, cword.pc, cword.rd, dword.alu_result, cword.rs1, dword.rs1_data, dword.imm_data);  
                          end else begin
                            $display("Cycle %d: COMMITTED @PC %x SUBIMM: R%d (%x) = R%d (%x) - IMM (%x)",
                                     cycle_i, cword.pc, cword.rd, dword.alu_result, cword.rs1, dword.rs1_data, dword.imm_data);               
                          end
    e_rvga_artop_sll    : $display("Cycle %d: COMMITTED @PC %x SLLIMM: R%d (%x) = R%d (%x) << IMM (%x)",
                                   cycle_i, cword.pc, cword.rd, dword.alu_result, cword.rs1, dword.rs1_data, dword.imm_data);  
    e_rvga_artop_slt    : $display("Cycle %d: COMMITTED @PC %x SLTIMM: R%d (%x) = R%d (%x) < IMM (%x)",
                                   cycle_i, cword.pc, cword.rd, dword.alu_result, cword.rs1, dword.rs1_data, dword.imm_data);  
    e_rvga_artop_sltu   : $display("Cycle %d: COMMITTED @PC %x SLTUIMM: R%d (%x) = R%d (%x) < IMM (%x)",
                                   cycle_i, cword.pc, cword.rd, dword.alu_result, cword.rs1, dword.rs1_data, dword.imm_data);  
    e_rvga_artop_xor    : $display("Cycle %d: COMMITTED @PC %x XORIMM: R%d (%x) = R%d (%x) ^ IMM (%x)",
                                   cycle_i, cword.pc, cword.rd, dword.alu_result, cword.rs1, dword.rs1_data, dword.imm_data);  
    e_rvga_artop_srx    : if(cword.funct7 == 0) begin
                            $display("Cycle %d: COMMITTED @PC %x SRAIMM: R%d (%x) = R%d (%x) >a IMM (%x)",
                                     cycle_i, cword.pc, cword.rd, dword.alu_result, cword.rs1, dword.rs1_data, dword.imm_data);  
                          end else begin
                            $display("Cycle %d: COMMITTED @PC %x SRLIMM: R%d (%x) = R%d (%x) > IMM (%x)",
                                     cycle_i, cword.pc, cword.rd, dword.alu_result, cword.rs1, dword.rs1_data, dword.imm_data);               
                          end
    e_rvga_artop_or     : $display("Cycle %d: COMMITTED @PC %x ORIMM: R%d (%x) = R%d (%x) | IMM (%x)",
                                   cycle_i, cword.pc, cword.rd, dword.alu_result, cword.rs1, dword.rs1_data, dword.imm_data); 
    e_rvga_artop_and    : $display("Cycle %d: COMMITTED @PC %x ANDIMM: R%d (%x) = R%d (%x) & IMM (%x)",
                                   cycle_i, cword.pc, cword.rd, dword.alu_result, cword.rs1, dword.rs1_data, dword.imm_data); 
  endcase
endtask

task print_reg(input rvga_cword cword, input rvga_dword dword);
  case(cword.funct3) 
    e_rvga_artop_addsub : if(cword.funct7 == 0) begin
                            $display("Cycle %d: COMMITTED @PC %x ADD: R%d (%x) = R%d (%x) + R%d (%x)",
                                     cycle_i, cword.pc, cword.rd, dword.alu_result, cword.rs1, dword.rs1_data, cword.rs2, dword.rs2_data);  
                          end else begin
                            $display("Cycle %d: COMMITTED @PC %x SUB: R%d (%x) = R%d (%x) - R%d (%x)",
                                     cycle_i, cword.pc, cword.rd, dword.alu_result, cword.rs1, dword.rs1_data, cword.rs2, dword.rs2_data);               
                          end
    e_rvga_artop_sll    : $display("Cycle %d: COMMITTED @PC %x SLL: R%d (%x) = R%d (%x) << R%d (%x)",
                                   cycle_i, cword.pc, cword.rd, dword.alu_result, cword.rs1, dword.rs1_data, cword.rs2, dword.rs2_data);  
    e_rvga_artop_slt    : $display("Cycle %d: COMMITTED @PC %x SLT: R%d (%x) = R%d (%x) < R%d (%x)",
                                   cycle_i, cword.pc, cword.rd, dword.alu_result, cword.rs1, dword.rs1_data, cword.rs2, dword.rs2_data);  
    e_rvga_artop_sltu   : $display("Cycle %d: COMMITTED @PC %x SLTU: R%d (%x) = R%d (%x) < R%d (%x)",
                                   cycle_i, cword.pc, cword.rd, dword.alu_result, cword.rs1, dword.rs1_data, cword.rs2, dword.rs2_data);  
    e_rvga_artop_xor    : $display("Cycle %d: COMMITTED @PC %x XOR: R%d (%x) = R%d (%x) ^ R%d (%x)",
                                   cycle_i, cword.pc, cword.rd, dword.alu_result, cword.rs1, dword.rs1_data, cword.rs2, dword.rs2_data);  
    e_rvga_artop_srx    : if(cword.funct7 == 0) begin
                            $display("Cycle %d: COMMITTED @PC %x SRA: R%d (%x) = R%d (%x) >a R%d (%x)",
                                     cycle_i, cword.pc, cword.rd, dword.alu_result, cword.rs1, dword.rs1_data, cword.rs2, dword.rs2_data);  
                          end else begin
                            $display("Cycle %d: COMMITTED @PC %x SRL: R%d (%x) = R%d (%x) > R%d (%x)",
                                     cycle_i, cword.pc, cword.rd, dword.alu_result, cword.rs1, dword.rs1_data, cword.rs2, dword.rs2_data);               
                          end
    e_rvga_artop_or     : $display("Cycle %d: COMMITTED @PC %x OR: R%d (%x) = R%d (%x) | R%d (%x)",
                                   cycle_i, cword.pc, cword.rd, dword.alu_result, cword.rs1, dword.rs1_data, cword.rs2, dword.rs2_data); 
    e_rvga_artop_and    : $display("Cycle %d: COMMITTED @PC %x AND: R%d (%x) = R%d (%x) & R%d (%x)",
                                   cycle_i, cword.pc, cword.rd, dword.alu_result, cword.rs1, dword.rs1_data, cword.rs2, dword.rs2_data); 
  endcase
endtask

task print_lui(input rvga_cword cword, input rvga_dword dword);
  $display("Cycle %d: COMMITTED @PC %x LUI: R%d (%x) = IMM (%x) (%x << 12)",
           cycle_i, cword.pc, cword.rd, dword.alu_result, dword.imm_data, dword.imm_data >> 12);
endtask

task print_auipc(input rvga_cword cword, input rvga_dword dword);
  $display("Cycle %d: COMMITTED @PC %x AUIPC: R%d (%x) = PC (%x) + IMM (%x) (%x << 12)",
           cycle_i, cword.pc, cword.rd, dword.alu_result, cword.pc, dword.imm_data, dword.imm_data >> 12);
endtask

task print_jal(input rvga_cword cword, input rvga_dword dword);
  $display("Cycle %d: COMMITTED @PC %x JAL: PC (%x) = PC (%x) + IMM (%x); R%x (%x) = PC (%x) + 4",
           cycle_i, cword.pc, dword.alu_result, cword.pc, dword.imm_data, cword.rd, dword.alu_result, cword.pc);
endtask

task print_jalr(input rvga_cword cword, input rvga_dword dword);
  $display("Cycle %d: COMMITTED @PC %x JALR: PC (%x) = R%x (%x) + IMM (%x); R%x (%x) = PC (%x) + 4",
           cycle_i, cword.pc, dword.alu_result, cword.rs1, dword.rs1_data, dword.imm_data, cword.rd, dword.alu_result, cword.pc);
endtask

task print_br(input rvga_cword cword, input rvga_dword dword);
  case(cword.funct3) 
    e_rvga_brop_beq  : $display("Cycle %d: COMMITTED @PC %x BEQ: if (R%x (%x) == R%x (%x)) PC (%x) = PC (%x) + IMM (%x)",
                                cycle_i, cword.pc, cword.rs1, dword.rs1_data, cword.rs2, dword.rs2_data, dword.alu_result, cycle_i, cword.pc, dword.imm_data);
    e_rvga_brop_bne  : $display("Cycle %d: COMMITTED @PC %x BNE: if (R%x (%x) != R%x (%x)) PC (%x) = PC (%x) + IMM (%x)",
                                cycle_i, cword.pc, cword.rs1, dword.rs1_data, cword.rs2, dword.rs2_data, dword.alu_result, cycle_i, cword.pc, dword.imm_data);
    e_rvga_brop_blt  : $display("Cycle %d: COMMITTED @PC %x BLT: if (R%x (%x) < R%x (%x)) PC (%x) = PC (%x) + IMM (%x)",
                                cycle_i, cword.pc, cword.rs1, dword.rs1_data, cword.rs2, dword.rs2_data, dword.alu_result, cycle_i, cword.pc, dword.imm_data);
    e_rvga_brop_bge  : $display("Cycle %d: COMMITTED @PC %x BGE: if (R%x (%x) > R%x (%x)) PC (%x) = PC (%x) + IMM (%x)",
                                cycle_i, cword.pc, cword.rs1, dword.rs1_data, cword.rs2, dword.rs2_data, dword.alu_result, cycle_i, cword.pc, dword.imm_data);
    e_rvga_brop_bltu : $display("Cycle %d: COMMITTED @PC %x BLTU: if (R%x (%x) == R%x (%x)) PC (%x) = PC (%x) + IMM (%x)",
                                cycle_i, cword.pc, cword.rs1, dword.rs1_data, cword.rs2, dword.rs2_data, dword.alu_result, cycle_i, cword.pc, dword.imm_data);
    e_rvga_brop_bgeu : $display("Cycle %d: COMMITTED @PC %x BGEU: if (R%x (%x) == R%x (%x)) PC (%x) = PC (%x) + IMM (%x)",
                                cycle_i, cword.pc, cword.rs1, dword.rs1_data, cword.rs2, dword.rs2_data, dword.alu_result, cycle_i, cword.pc, dword.imm_data);
  endcase
endtask

task print_ld(rvga_cword cword, input rvga_dword dword);
  case(cword.funct3)
    e_rvga_ldop_lb  : $display("Cycle %d: COMMITTED @PC %x LB: R%x (%x) = BYTE(MEM[%x]) (%x)",
                               cycle_i, cword.pc, cword.rd, dword.alu_result, dword.alu_result, dword.ld_result);
    e_rvga_ldop_lh  : $display("Cycle %d: COMMITTED @PC %x LH: R%x (%x) = HALF(MEM[%x]) (%x)",
                               cycle_i, cword.pc, cword.rd, dword.alu_result, dword.alu_result, dword.ld_result);
    e_rvga_ldop_lw  : $display("Cycle %d: COMMITTED @PC %x LW: R%x (%x) = MEM[%x] (%x)",
                               cycle_i, cword.pc, cword.rd, dword.alu_result, dword.alu_result, dword.ld_result);
    e_rvga_ldop_lbu : $display("Cycle %d: COMMITTED @PC %x LBU: R%x (%x) = UBYTE(MEM[%x]) (%x)",
                               cycle_i, cword.pc, cword.rd, dword.alu_result, dword.alu_result, dword.ld_result);
    e_rvga_ldop_lhu : $display("Cycle %d: COMMITTED @PC %x LHU: R%x (%x) = UHALF (MEM[%x]) (%x)",
                               cycle_i, cword.pc, cword.rd, dword.alu_result, dword.alu_result, dword.ld_result);
  endcase
endtask

task print_st(rvga_cword cword, input rvga_dword dword);
  case(cword.funct3)
    e_rvga_strop_sb  : $display("Cycle %d: COMMITTED @PC %x SB: MEM[(R%x (%x) + IMM (%x)) (%x)] = BYTE(R%x (%x))",
                               cycle_i, cword.pc, cword.rs1, dword.rs1_data, dword.imm_data, dword.alu_result, cword.rs2, dword.rs2_data);
    e_rvga_strop_sh  : $display("Cycle %d: COMMITTED @PC %x SH: MEM[(R%x (%x) + IMM (%x)) (%x)] = HALF(R%x (%x))",
                                cycle_i, cword.pc, cword.rs1, dword.rs1_data, dword.imm_data, dword.alu_result, cword.rs2, dword.rs2_data);
    e_rvga_strop_sw  : $display("Cycle %d: COMMITTED @PC %x SW: MEM[(R%x (%x) + IMM (%x)) (%x)] = R%x (%x)",
                                cycle_i, cword.pc, cword.rs1, dword.rs1_data, dword.imm_data, dword.alu_result, cword.rs2, dword.rs2_data);
  endcase
endtask

  
always_ff @(posedge clk_i) begin
  if(enable_p) begin
    if(cword_i.v) begin
      case(cword_i.opcode) 
        e_rvga_opcode_lui   : print_lui(cword_i, dword_i);
        e_rvga_opcode_auipc : print_auipc(cword_i, dword_i);
        e_rvga_opcode_jal   : print_jal(cword_i, dword_i);
        e_rvga_opcode_jalr  : print_jalr(cword_i, dword_i);
        e_rvga_opcode_br    : print_br(cword_i, dword_i);
        e_rvga_opcode_ld    : print_ld(cword_i, dword_i);
        e_rvga_opcode_st    : print_st(cword_i, dword_i);
        e_rvga_opcode_imm   : print_imm(cword_i, dword_i);
        e_rvga_opcode_reg   : print_reg(cword_i, dword_i);
        e_rvga_opcode_fence : $display("Cycle %d: @PC %x, ERROR: FENCE not implemented!", cycle_i, cword_i.pc);
        e_rvga_opcode_misc  : $display("Cycle %d: @PC %x, ERROR: MISC not implemented!", cycle_i, cword_i.pc);
      endcase
    end
    solve_halting_problem(cword_i, dword_i);
  end
end
  
endmodule : rvga_nonsynth_commit_monitor
