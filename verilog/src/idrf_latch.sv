import rvga_types::*;

module idrf_latch
  (input logic clk_i
   , input logic rst_i

   , input logic stall_v_i

   , input rvga_cword cword_i
   , input rvga_cword cword_o

   );

   dff #(.width_p($bits(rvga_cword)))
  cword (.clk_i(clk_i)
        ,.rst_i(rst_i)
        ,.w_v_i(~stall_v_i)
         
        ,.i(cword_n)
        ,.o(cword_r)
        );

endmodule : idrf_latch
