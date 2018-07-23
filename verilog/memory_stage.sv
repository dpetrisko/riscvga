`include "rvga_types.sv"
import rvga_types::*;

module memory_stage
  (input logic clk_i
   , input logic rst_i
   
   , input logic stall_v_i
   , input logic flush_v_i
   
   , input rvga_memory_cword cword_i
   , output rvga_writeback_cword cword_o
   
   , output logic dmem_r_v_o
   , output logic dmem_w_v_o
   , output rvga_word dmem_addr_o
   , input rvga_word dmem_data_i
   , output rvga_word dmem_data_o
         
   , output logic br_v_o
   );
 
 logic cmux_sel;
 logic cword_w_v;
 rvga_writeback_cword cword_n, cword_r, cmux_o, nop;
 rvga_word ld_result;
   
  memory_ctl #()
          ctl (.stall_v_i(stall_v_i)
               ,.flush_v_i(flush_v_i)
               
               ,.cmux_sel_o(cmux_sel)
               ,.cword_w_v_o(cword_w_v)
               
               ,.dmem_r_v_i(cword_i.dmem_r_v)
               ,.dmem_w_v_i(cword_i.dmem_w_v)
               
               ,.dmem_r_v_o(dmem_r_v_o)
               ,.dmem_w_v_o(dmem_w_v_o)
               );
              
  memory_dp #()
          dp (.alu_result_i(cword_i.alu_or_ld_result)
              ,.st_result_i(cword_i.rs2_data)
               
              ,.funct3_i(cword_i.funct3)
              ,.ld_result_o(ld_result)
               
              ,.dmem_addr_o(dmem_addr_o)
              ,.dmem_data_i(dmem_data_i)
              ,.dmem_data_o(dmem_data_o)
              );
                
   mux #(.els_p(2)
         ,.width_p($bits(rvga_writeback_cword))
         )
    cmux(.sel_i(cmux_sel)
         ,.i({nop, cword_n})
         ,.o(cmux_o)
         );
                  
   dff #(.width_p($bits(rvga_writeback_cword))
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
  cword_n.alu_or_ld_result = cword_i.dmem_r_v ? ld_result : cword_i.alu_or_ld_result;
  cword_n.bru_result = cword_i.bru_result;
  
  cword_o = cword_r;
  
  br_v_o = cword_r.br_v;
end

endmodule : memory_stage

