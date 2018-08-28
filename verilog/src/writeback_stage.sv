import rvga_types::*;

module writeback_stage  (input logic clk_i
   , input logic rst_i
   
   , input logic stall_v_i
   
   , input rvga_cword cword_i
   
   , input rvga_word alu_or_ld_result_i
   
   , output rvga_reg rd_o
   , output rvga_word rd_data_o 
   , output logic rd_w_v_o
   );
   
logic rdmux_sel;
rvga_word pc_plus4, rvga_zero;
rvga_word rd_data_r;
rvga_word rdmux_o;
                
  mux #(.els_p(2)
        ,.width_p($bits(rvga_word))
        )
 rdmux (.sel_i(cword_i.jmp_v)
        ,.i({pc_plus4, rd_data_r})
        ,.o(rdmux_o)
        );    
    
  adder #(.width_p($bits(rvga_word)))
  pc_inc (.a_i(cword_i.pc)
          ,.b_i(32'd4)
          ,.o(pc_plus4)
          );   
       
  dff #(.width_p($bits(rvga_word)))
 rd_data (.clk_i(clk_i)
          ,.rst_i(rst_i)
          ,.w_v_i(~stall_v_i)
          
          ,.i(alu_or_ld_result_i)
          ,.o(rd_data_r)
          );
       
always_comb begin
  
  rd_o = cword_i.rd;
  rd_w_v_o = cword_i.rd_w_v;
  rd_data_o = rdmux_o;
end

endmodule : writeback_stage

