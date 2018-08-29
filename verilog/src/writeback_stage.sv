import rvga_types::*;

module writeback_stage  
  (input logic clk_i
   , input logic rst_i
   , input logic stall_v_i
   
   , input rvga_cword cword_i
   
   , input rvga_word alu_or_ld_result_i
   
   , input logic btaken_i

   , output logic br_v_o
   , output logic btaken_o
   , output rvga_word btgt_o

   , output rvga_reg rd_o
   , output rvga_word rd_data_o 
   , output logic rd_w_v_o
   );
   
logic rdmux_sel;
rvga_word pc_plus4, rvga_zero;
rvga_word rdmux_o;
                
  mux #(.els_p(2)
        ,.width_p($bits(rvga_word))
        )
 rdmux (.sel_i(cword_i.jmp_v)
        ,.i({pc_plus4, alu_or_ld_result_i})
        ,.o(rdmux_o)
        );    
    
  adder #(.width_p($bits(rvga_word)))
  pc_inc (.a_i(cword_i.pc)
          ,.b_i(32'd4)
          ,.o(pc_plus4)
          );   
       
always_comb begin
  rd_o = cword_i.rd;
  rd_w_v_o = cword_i.rd_w_v;
  rd_data_o = rdmux_o;

  br_v_o = cword_i.jmp_v || cword_i.br_v;
  btaken_o = btaken_i;
  btgt_o = alu_or_ld_result_i;
end

endmodule : writeback_stage

