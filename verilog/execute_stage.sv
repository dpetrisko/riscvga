`include "rvga_types.sv"
import rvga_types::*;

module execute_stage
  (input logic clk_i
   , input logic rst_i
   
   , input logic stall_v_i
   , input logic flush_v_i
   
   , input rvga_rfetch_cword cword_i
   , output rvga_execute_cword cword_o
   );
   
logic amux_sel, bmux_sel, cmux_sel;
logic cword_w_v;   
rvga_execute_cword cword_n, cword_r, cmux_o;
rvga_word alu_result;
   
  execute_ctl #()
           ctl (.stall_v_i(stall_v_i)
                ,.flush_v_i(flush_v_i)
              
                ,.cmux_sel_o(cmux_sel)
                ,.cword_w_v_o(cword_w_v)
                
                ,.imm_v_i(cword_i.imm_v)
                
                ,.amux_sel_o(amux_sel)
                ,.bmux_sel_o(bmux_sel)
                );
             
  execute_dp #()
           dp (.clk_i(clk_i)
               ,.rst_i(rst_i)
               
               ,.amux_sel_i(amux_sel)
               ,.bmux_sel_i(bmux_sel)
               
               ,.artop_i(cword_i.funct3)
               ,.alu_alt_i(cword_i.funct7[5])
               ,.imm_i(cword_i.imm)
               ,.rs1_data_i(cword_i.rs1_data)
               ,.rs2_data_i(cword_i.rs2_data)
       
               ,.alu_result_o(alu_result)
               );
               
    mux #(.els_p(2)
         ,.width_p($bits(rvga_execute_cword))
         )
    cmux(.sel_i(cmux_sel)
         ,.i({'0, cword_n})
         ,.o(cmux_o)
         );
                  
   dff #(.width_p($bits(rvga_execute_cword))
         ) 
  cword (.clk_i(clk_i)
        ,.rst_i(rst_i)
        ,.w_v_i(cword_w_v)
         
        ,.i(cmux_o)
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
  cword_n.imm = cword_i.imm;
  cword_n.rs1_data = cword_i.rs1_data;
  cword_n.rs2_data = cword_i.rs2_data;

  cword_n.alu_result = alu_result;
 
  cword_o = cword_r;
end


endmodule : execute_stage

