import rvga_types::*;

module rvga_nonsynth_commit_monitor #(parameter enable_p = 0)
  ( input integer cycle_i
    , input logic clk_i
    , input rvga_cword cword_i
    , input rvga_dword dword_i
  );
  
task print_imm(input rvga_cword cword);
  case(cword_i.funct3) 
    e_rvga_artop_addsub : if(cword_i.funct7 == 0) begin
                            $display("Cycle %d: COMMITTED @PC %x ADDIMM: R%d (%x) = R%d (%x) + IMM (%x)\n",
                                     cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, cword_i.rs1, dword_i.rs1_data, dword_i.imm_data);  
                          end else begin
                            $display("Cycle %d: COMMITTED @PC %x SUBIMM: R%d (%x) = R%d (%x) - IMM (%x)\n",
                                     cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, cword_i.rs1, dword_i.rs1_data, dword_i.imm_data);               
                          end
    e_rvga_artop_sll    : $display("Cycle %d: COMMITTED @PC %x SLLIMM: R%d (%x) = R%d (%x) << IMM (%x)\n",
                                   cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, cword_i.rs1, dword_i.rs1_data, dword_i.imm_data);  
    e_rvga_artop_slt    : $display("Cycle %d: COMMITTED @PC %x SLTIMM: R%d (%x) = R%d (%x) < IMM (%x)\n",
                                   cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, cword_i.rs1, dword_i.rs1_data, dword_i.imm_data);  
    e_rvga_artop_sltu   : $display("Cycle %d: COMMITTED @PC %x SLTUIMM: R%d (%x) = R%d (%x) < IMM (%x)\n",
                                   cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, cword_i.rs1, dword_i.rs1_data, dword_i.imm_data);  
    e_rvga_artop_xor    : $display("Cycle %d: COMMITTED @PC %x XORIMM: R%d (%x) = R%d (%x) ^ IMM (%x)\n",
                                   cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, cword_i.rs1, dword_i.rs1_data, dword_i.imm_data);  
    e_rvga_artop_srx    : if(cword_i.funct7 == 0) begin
                            $display("Cycle %d: COMMITTED @PC %x SRAIMM: R%d (%x) = R%d (%x) >a IMM (%x)\n",
                                     cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, cword_i.rs1, dword_i.rs1_data, dword_i.imm_data);  
                          end else begin
                            $display("Cycle %d: COMMITTED @PC %x SRLIMM: R%d (%x) = R%d (%x) > IMM (%x)\n",
                                     cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, cword_i.rs1, dword_i.rs1_data, dword_i.imm_data);               
                          end
    e_rvga_artop_or     : $display("Cycle %d: COMMITTED @PC %x ORIMM: R%d (%x) = R%d (%x) | IMM (%x)\n",
                                   cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, cword_i.rs1, dword_i.rs1_data, dword_i.imm_data); 
    e_rvga_artop_and    : $display("Cycle %d: COMMITTED @PC %x ANDIMM: R%d (%x) = R%d (%x) & IMM (%x)\n",
                                   cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, cword_i.rs1, dword_i.rs1_data, dword_i.imm_data); 
  endcase
endtask

task print_reg(input rvga_cword cword);
  case(cword_i.funct3) 
    e_rvga_artop_addsub : if(cword_i.funct7 == 0) begin
                            $display("Cycle %d: COMMITTED @PC %x ADD: R%d (%x) = R%d (%x) + R%d (%x)\n",
                                     cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, cword_i.rs1, dword_i.rs1_data, cword_i.rs2, dword_i.rs2_data);  
                          end else begin
                            $display("Cycle %d: COMMITTED @PC %x SUB: R%d (%x) = R%d (%x) - R%d (%x)\n",
                                     cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, cword_i.rs1, dword_i.rs1_data, cword_i.rs2, dword_i.rs2_data);               
                          end
    e_rvga_artop_sll    : $display("Cycle %d: COMMITTED @PC %x SLL: R%d (%x) = R%d (%x) << R%d (%x)\n",
                                   cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, cword_i.rs1, dword_i.rs1_data, cword_i.rs2, dword_i.rs2_data);  
    e_rvga_artop_slt    : $display("Cycle %d: COMMITTED @PC %x SLT: R%d (%x) = R%d (%x) < R%d (%x)\n",
                                   cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, cword_i.rs1, dword_i.rs1_data, cword_i.rs2, dword_i.rs2_data);  
    e_rvga_artop_sltu   : $display("Cycle %d: COMMITTED @PC %x SLTU: R%d (%x) = R%d (%x) < R%d (%x)\n",
                                   cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, cword_i.rs1, dword_i.rs1_data, cword_i.rs2, dword_i.rs2_data);  
    e_rvga_artop_xor    : $display("Cycle %d: COMMITTED @PC %x XOR: R%d (%x) = R%d (%x) ^ R%d (%x)\n",
                                   cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, cword_i.rs1, dword_i.rs1_data, cword_i.rs2, dword_i.rs2_data);  
    e_rvga_artop_srx    : if(cword_i.funct7 == 0) begin
                            $display("Cycle %d: COMMITTED @PC %x SRA: R%d (%x) = R%d (%x) >a R%d (%x)\n",
                                     cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, cword_i.rs1, dword_i.rs1_data, cword_i.rs2, dword_i.rs2_data);  
                          end else begin
                            $display("Cycle %d: COMMITTED @PC %x SRL: R%d (%x) = R%d (%x) > R%d (%x)\n",
                                     cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, cword_i.rs1, dword_i.rs1_data, cword_i.rs2, dword_i.rs2_data);               
                          end
    e_rvga_artop_or     : $display("Cycle %d: COMMITTED @PC %x OR: R%d (%x) = R%d (%x) | R%d (%x)\n",
                                   cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, cword_i.rs1, dword_i.rs1_data, cword_i.rs2, dword_i.rs2_data); 
    e_rvga_artop_and    : $display("Cycle %d: COMMITTED @PC %x AND: R%d (%x) = R%d (%x) & R%d (%x)\n",
                                   cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, cword_i.rs1, dword_i.rs1_data, cword_i.rs2, dword_i.rs2_data); 
  endcase
endtask

task print_lui(input rvga_cword cword);
  $display("Cycle %d: COMMITTED @PC %x LUI: R%d (%x) = IMM (%x) (%x << 12)\n",
           cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, dword_i.imm_data, dword_i.imm_data >> 12);
endtask

task print_auipc(input rvga_cword cword);
  $display("Cycle %d: COMMITTED @PC %x AUIPC: R%d (%x) = PC (%x) + IMM (%x) (%x << 12)\n",
           cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, cword_i.pc, dword_i.imm_data, dword_i.imm_data >> 12);
endtask

task print_jal(input rvga_cword cword);
  $display("Cycle %d: COMMITTED @PC %x JAL: PC (%x) = PC (%x) + IMM (%x); R%x (%x) = PC (%x) + 4\n",
           cycle_i, cword_i.pc, dword_i.alu_result, cword_i.pc, dword_i.imm_data, cword_i.rd, dword_i.alu_result, cword_i.pc);
endtask

task print_jalr(input rvga_cword cword);
  $display("Cycle %d: COMMITTED @PC %x JALR: PC (%x) = R%x (%x) + IMM (%x); R%x (%x) = PC (%x) + 4\n",
           cycle_i, cword_i.pc, dword_i.alu_result, cword_i.rs1, dword_i.rs1_data, dword_i.imm_data, cword_i.rd, dword_i.alu_result, cword_i.pc);
endtask

task print_br(input rvga_cword cword);
  case(cword_i.funct3) 
    e_rvga_brop_beq  : $display("Cycle %d: COMMITTED @PC %x BEQ: if (R%x (%x) == R%x (%x)) PC (%x) = PC (%x) + IMM (%x)\n",
                                cycle_i, cword_i.pc, cword_i.rs1, dword_i.rs1_data, cword_i.rs2, dword_i.rs2_data, dword_i.alu_result, cycle_i, cword_i.pc, dword_i.imm_data);
    e_rvga_brop_bne  : $display("Cycle %d: COMMITTED @PC %x BNE: if (R%x (%x) != R%x (%x)) PC (%x) = PC (%x) + IMM (%x)\n",
                                cycle_i, cword_i.pc, cword_i.rs1, dword_i.rs1_data, cword_i.rs2, dword_i.rs2_data, dword_i.alu_result, cycle_i, cword_i.pc, dword_i.imm_data);
    e_rvga_brop_blt  : $display("Cycle %d: COMMITTED @PC %x BLT: if (R%x (%x) < R%x (%x)) PC (%x) = PC (%x) + IMM (%x)\n",
                                cycle_i, cword_i.pc, cword_i.rs1, dword_i.rs1_data, cword_i.rs2, dword_i.rs2_data, dword_i.alu_result, cycle_i, cword_i.pc, dword_i.imm_data);
    e_rvga_brop_bge  : $display("Cycle %d: COMMITTED @PC %x BGE: if (R%x (%x) > R%x (%x)) PC (%x) = PC (%x) + IMM (%x)\n",
                                cycle_i, cword_i.pc, cword_i.rs1, dword_i.rs1_data, cword_i.rs2, dword_i.rs2_data, dword_i.alu_result, cycle_i, cword_i.pc, dword_i.imm_data);
    e_rvga_brop_bltu : $display("Cycle %d: COMMITTED @PC %x BLTU: if (R%x (%x) == R%x (%x)) PC (%x) = PC (%x) + IMM (%x)\n",
                                cycle_i, cword_i.pc, cword_i.rs1, dword_i.rs1_data, cword_i.rs2, dword_i.rs2_data, dword_i.alu_result, cycle_i, cword_i.pc, dword_i.imm_data);
    e_rvga_brop_bgeu : $display("Cycle %d: COMMITTED @PC %x BGEU: if (R%x (%x) == R%x (%x)) PC (%x) = PC (%x) + IMM (%x)\n",
                                cycle_i, cword_i.pc, cword_i.rs1, dword_i.rs1_data, cword_i.rs2, dword_i.rs2_data, dword_i.alu_result, cycle_i, cword_i.pc, dword_i.imm_data);
  endcase
endtask

task print_ld(rvga_cword cword);
  case(cword_i.funct3)
    e_rvga_ldop_lb  : $display("Cycle %d: COMMITTED @PC %x LB: R%x (%x) = BYTE(MEM[%x]) (%x)\n",
                               cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, dword_i.alu_result, dword_i.ld_result);
    e_rvga_ldop_lh  : $display("Cycle %d: COMMITTED @PC %x LH: R%x (%x) = HALF(MEM[%x]) (%x)\n",
                               cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, dword_i.alu_result, dword_i.ld_result);
    e_rvga_ldop_lw  : $display("Cycle %d: COMMITTED @PC %x LW: R%x (%x) = MEM[%x] (%x)\n",
                               cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, dword_i.alu_result, dword_i.ld_result);
    e_rvga_ldop_lbu : $display("Cycle %d: COMMITTED @PC %x LBU: R%x (%x) = UBYTE(MEM[%x]) (%x)\n",
                               cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, dword_i.alu_result, dword_i.ld_result);
    e_rvga_ldop_lhu : $display("Cycle %d: COMMITTED @PC %x LHU: R%x (%x) = UHALF (MEM[%x]) (%x)\n",
                               cycle_i, cword_i.pc, cword_i.rd, dword_i.alu_result, dword_i.alu_result, dword_i.ld_result);
  endcase
endtask

task print_st(rvga_cword cword);
  case(cword_i.funct3)
    e_rvga_strop_sb  : $display("Cycle %d: COMMITTED @PC %x SB: MEM[(R%x (%x) + IMM (%x)) (%x)] = BYTE(R%x (%x))\n",
                               cycle_i, cword_i.pc, cword_i.rs1, dword_i.rs1_data, dword_i.imm_data, dword_i.alu_result, cword_i.rs2, dword_i.rs2_data);
    e_rvga_strop_sh  : $display("Cycle %d: COMMITTED @PC %x SH: MEM[(R%x (%x) + IMM (%x)) (%x)] = HALF(R%x (%x))\n",
                                cycle_i, cword_i.pc, cword_i.rs1, dword_i.rs1_data, dword_i.imm_data, dword_i.alu_result, cword_i.rs2, dword_i.rs2_data);
    e_rvga_strop_sw  : $display("Cycle %d: COMMITTED @PC %x SW: MEM[(R%x (%x) + IMM (%x)) (%x)] = R%x (%x)\n",
                                cycle_i, cword_i.pc, cword_i.rs1, dword_i.rs1_data, dword_i.imm_data, dword_i.alu_result, cword_i.rs2, dword_i.rs2_data);
  endcase
endtask

  
always_ff @(posedge clk_i) begin
  if(enable_p) begin
    if(cword_i.v) begin
      case(cword_i.opcode) 
        e_rvga_opcode_lui   : print_lui(cword_i);
        e_rvga_opcode_auipc : print_auipc(cword_i);
        e_rvga_opcode_jal   : print_jal(cword_i);
        e_rvga_opcode_jalr  : print_jalr(cword_i);
        e_rvga_opcode_br    : print_br(cword_i);
        e_rvga_opcode_ld    : print_ld(cword_i);
        e_rvga_opcode_st    : print_st(cword_i);
        e_rvga_opcode_imm   : print_imm(cword_i);
        e_rvga_opcode_reg   : print_reg(cword_i);
        e_rvga_opcode_fence : $display("Cycle %d: @PC %x, ERROR: FENCE not implemented!\n", cycle_i, cword_i.pc);
        e_rvga_opcode_misc  : $display("Cycle %d: @PC %x, ERROR: MISC not implemented!\n", cycle_i, cword_i.pc);
      endcase
    end
  end
end
  
endmodule : rvga_nonsynth_commit_monitor
