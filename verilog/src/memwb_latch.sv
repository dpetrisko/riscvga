import rvga_types::*;

module memwb_latch
  (input logic clk_i
   , input logic rst_i

   , input logic stall_v_i

   , input rvga_cword cword_i
   , output rvga_cword cword_o
   );

rvga_cword cword_n, cword_r;

   dff #(.width_p($bits(rvga_cword)))
  cword (.clk_i(clk_i)
        ,.rst_i(rst_i)
        ,.w_v_i(~stall_v_i)
         
        ,.i(cword_i)
        ,.o(cword_r)
        );

always_comb begin
  cword_n = cword_i;
  cword_o = cword_r;
end

endmodule : memwb_latch
