`include "rvga_types.sv"
import rvga_types::*;

module writeback_stage
  (input logic clk_i
   , input logic rst_i
   
   , input logic stall_v_i
   
   , input rvga_memory_cword cword_i
   , output rvga_writeback_cword cword_o
   
   , output rvga_word br_tgt_o
   , output logic br_v_o
   , output logic btaken_o
   
   , output rvga_reg rd_o
   , output rvga_word rd_data_o 
   , output logic rd_w_v_o
   );
   
rvga_writeback_cword cmux_o, cword_n, cword_r;
logic cword_w_v;   
logic[1:0] rdmux_sel;

  writeback_ctl #()
           ctl (.stall_v_i(stall_v_i)
                
                ,.cword_w_v_o(cword_w_v)
                
                ,.br_v_i(cword_i.br_v)
                ,.bru_result_i(cword_i.bru_result)
                ,.jmp_v_i(cword_i.jmp_v)
                                 
                ,.dmem_r_v_i(cword_i.dmem_r_v)
                ,.dmem_w_v_i(cword_i.dmem_w_v)
                
                ,.rdmux_sel_o(rdmux_sel)
                ,.btaken_o(btaken_o)
                );
               
  writeback_dp #()
             dp (.pc_i(cword_i.pc)
                 ,.ld_result_i(cword_i.ld_result)
                 ,.alu_result_i(cword_i.alu_result)
             
                 ,.rdmux_sel_i(rdmux_sel)
                 
                 ,.rd_data_o(rd_data_o)
                 );
                     
 dff #(.width_p($bits(rvga_writeback_cword))
       ) 
cword (.clk_i(clk_i)
       ,.rst_i(rst_i)
       ,.w_v_i(cword_w_v)
       
       ,.i(cword_n)
       ,.o(cword_r)
       );
       
always_comb begin
  cword_n.pc = cword_i.pc;
  cword_n.opcode = cword_i.opcode;  
  cword_n.rs1 = cword_i.rs1;
  cword_n.rs2 = cword_i.rs2;
  cword_n.rd = cword_i.rd;
  cword_n.funct3 = cword_i.funct3;
  cword_n.funct7 = cword_i.funct7;
  cword_n.br_v = cword_i.br_v;
  cword_n.rd_w_v = cword_i.rd_w_v;
  cword_n.imm_v = cword_i.imm_v;
  cword_n.dmem_r_v = cword_i.dmem_r_v;
  cword_n.dmem_w_v = cword_i.dmem_w_v;
  cword_n.addpc_v = cword_i.addpc_v;
  cword_n.jmp_v = cword_i.jmp_v;
  cword_n.imm = cword_i.imm;
  cword_n.rs1_data = cword_i.rs1_data;
  cword_n.rs2_data = cword_i.rs2_data;
  cword_n.alu_result = cword_i.alu_result;
  cword_n.bru_result = cword_i.bru_result;
  cword_n.ld_result = cword_i.ld_result;
  
  cword_o = cword_r;
  
  br_tgt_o = cword_r.alu_result;
  br_v_o = cword_r.br_v;
  rd_o = cword_r.rd;
  rd_w_v_o = cword_r.rd_w_v;
  
  br_v_o = cword_r.br_v;
end

endmodule : writeback_stage

