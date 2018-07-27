`include "rvga_types.sv"
import rvga_types::*;

module writeback_stage  (input logic clk_i
   , input logic rst_i
   
   , input logic stall_v_i
   
   , input rvga_cword cword_i
   , output rvga_cword cword_o
   
   , input rvga_dword dword_i
   , output rvga_dword dword_o
   
   , input rvga_word alu_or_ld_result_i
   
   , output rvga_reg rd_o
   , output rvga_word rd_data_o 
   , output logic rd_w_v_o
   );
   
rvga_cword cword_n, cword_r;
rvga_dword dword_n, dword_r; 
logic rdmux_sel;
rvga_word pc_plus4, rvga_zero;
rvga_word rd_data_r;
rvga_word rdmux_o;
                
  mux #(.els_p(2)
        ,.width_p($bits(rvga_word))
        )
 rdmux (.sel_i(cword_r.jmp_v)
        ,.i({pc_plus4, rd_data_r})
        ,.o(rdmux_o)
        );    
    
  adder #(.width_p($bits(rvga_word)))
  pc_inc (.a_i(cword_r.pc)
          ,.b_i(32'd4)
          ,.o(pc_plus4)
          );   
                     
 dff #(.width_p($bits(rvga_cword)))
cword (.clk_i(clk_i)
       ,.rst_i(rst_i)
       ,.w_v_i(~stall_v_i)
       
       ,.i(cword_n)
       ,.o(cword_r)
       );
       
dff #(.width_p($bits(rvga_dword)))
  dword (.clk_i(clk_i)
         ,.rst_i(rst_i)
         ,.w_v_i(~stall_v_i)
        
         ,.i(dword_n)
         ,.o(dword_r)
         );
       
  dff #(.width_p($bits(rvga_word)))
 rd_data (.clk_i(clk_i)
          ,.rst_i(rst_i)
          ,.w_v_i(~stall_v_i)
          
          ,.i(alu_or_ld_result_i)
          ,.o(rd_data_r)
          );
       
always_comb begin
  cword_n = cword_i;
  dword_n = dword_i;
  
  dword_n.ld_result = alu_or_ld_result_i;
  
  cword_o = cword_r;
  dword_o = dword_r;
  
  rd_o = cword_r.rd;
  rd_w_v_o = cword_r.rd_w_v;
  rd_data_o = rdmux_o;
end

endmodule : writeback_stage

