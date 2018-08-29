import rvga_types::*;

module memwb_latch
  (input logic clk_i
   , input logic rst_i
   , input logic stall_v_i

   , input rvga_cword cword_i
   , output rvga_cword cword_o

   , input rvga_word alu_or_ld_result_i
   , output rvga_word alu_or_ld_result_o

   , input logic btaken_i
   , output logic btaken_o
   );

rvga_cword cword_n, cword_r;
rvga_word alu_or_ld_result_n, alu_or_ld_result_r;
logic btaken_n, btaken_r;

   dff #(.width_p($bits(rvga_cword)))
  cword (.clk_i(clk_i)
        ,.rst_i(rst_i)
        ,.w_v_i(~stall_v_i)
         
        ,.i(cword_i)
        ,.o(cword_r)
        );

             dff #(.width_p($bits(rvga_word)))
 alu_or_ld_result (.clk_i(clk_i)
                   ,.rst_i(rst_i)
                   ,.w_v_i(~stall_v_i)
          
                   ,.i(alu_or_ld_result_n)
                   ,.o(alu_or_ld_result_r)
                   );
      
   dff #(.width_p($bits(logic)))
 btaken (.clk_i(clk_i)
         ,.rst_i(rst_i)
         ,.w_v_i(~stall_v_i)
          
         ,.i(btaken_n)
         ,.o(btaken_r)
         );

always_comb begin
  cword_n = cword_i;
  cword_o = cword_r;

  alu_or_ld_result_n = alu_or_ld_result_i;
  alu_or_ld_result_o = alu_or_ld_result_r;

  btaken_n = btaken_i;
  btaken_o = btaken_r;
end

endmodule : memwb_latch
