`include "rvga_types.sv"
import rvga_types::*;

module execute_stage
  (input logic clk_i
   , input logic rst_i
   
   , input logic stall_v_i
   , input logic flush_v_i
   
   , input rvga_execute_cword cword_i
   , output rvga_memory_cword cword_o
                  
   , input logic forward_memory_execute_rs1_v_i
   , input logic forward_memory_execute_rs2_v_i
   , input logic forward_writeback_execute_rs1_v_i
   , input logic forward_writeback_execute_rs2_v_i 
   
   , input rvga_word memory_rd_data_i
   , input rvga_word writeback_rd_data_i
      
   , output logic br_v_o
   );
   
logic cmux_sel;
logic[1:0] amux_sel, bmux_sel;
logic cword_w_v;   
rvga_memory_cword cword_n, cword_r, cmux_o, nop;
rvga_word alu_result;
logic bru_result;
logic add_override_v;

  execute_ctl #()
           ctl (.stall_v_i(stall_v_i)
                ,.flush_v_i(flush_v_i)
              
                ,.cmux_sel_o(cmux_sel)
                ,.cword_w_v_o(cword_w_v)
                
                ,.dmem_r_v_i(cword_i.dmem_r_v)
                ,.dmem_w_v_i(cword_i.dmem_w_v)
                ,.imm_v_i(cword_i.imm_v)
                ,.addpc_v_i(cword_i.addpc_v)
                
                ,.forward_memory_execute_rs1_v_i(forward_memory_execute_rs1_v_i)
                ,.forward_memory_execute_rs2_v_i(forward_memory_execute_rs2_v_i)
                ,.forward_writeback_execute_rs1_v_i(forward_writeback_execute_rs1_v_i)
                ,.forward_writeback_execute_rs2_v_i(forward_writeback_execute_rs2_v_i)   
                
                ,.amux_sel_o(amux_sel)
                ,.bmux_sel_o(bmux_sel)
                ,.add_override_v_o(add_override_v)
                );
             
  execute_dp #()
           dp (.amux_sel_i(amux_sel)
               ,.bmux_sel_i(bmux_sel)
               
               ,.pc_i(cword_i.pc)
               ,.op_i(cword_i.funct3)
               ,.alu_alt_i(cword_i.funct7[5])
               ,.alu_add_override_v_i(add_override_v)
               ,.imm_i(cword_i.imm)
               ,.rs1_data_i(cword_i.rs1_data)
               ,.rs2_data_i(cword_i.rs2_data)
       
               ,.alu_result_o(alu_result)
               ,.bru_result_o(bru_result)
               
               ,.memory_rd_data_i(memory_rd_data_i)
               ,.writeback_rd_data_i(writeback_rd_data_i)
               );
               
    mux #(.els_p(2)
         ,.width_p($bits(rvga_memory_cword))
         )
    cmux(.sel_i(cmux_sel)
         ,.i({nop, cword_n})
         ,.o(cmux_o)
         );
                  
   dff #(.width_p($bits(rvga_memory_cword))
         ) 
  cword (.clk_i(clk_i)
        ,.rst_i(rst_i)
        ,.w_v_i(cword_w_v)
         
        ,.i(cmux_o)
        ,.o(cword_r)
        );

assign nop = '0;

always_comb begin
  cword_n.v = cword_i.v;
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

  cword_n.alu_or_ld_result = alu_result;
  cword_n.bru_result = bru_result;
 
  cword_o = cword_r;
  
  br_v_o = cword_r.br_v;
end


endmodule : execute_stage

