import rvga_types::*;

module ifid_latch
  (input logic clk_i
   , input logic rst_i

   , input logic stall_v_i
   , input logic bubble_v_i

   , input rvga_word inst_pc_i
   , input rvga_word inst_i

   , output logic inst_v_o
   , output rvga_word inst_pc_o
   , output rvga_word inst_o
   );

rvga_word inst_pc_r;
rvga_word inst_r;
logic inst_v_r;

   dff #(.width_p($bits(rvga_word))
         )
 inst_pc(.clk_i(clk_i)
         ,.rst_i(rst_i)
             
         ,.i(inst_pc_i)
         ,.w_v_i(~(stall_v_i || bubble_v_i))
         ,.o(inst_pc_r)
         );

   dff #(.width_p($bits(rvga_word))
         )
    inst(.clk_i(clk_i)
         ,.rst_i(rst_i)
             
         ,.i(inst_i)
         ,.w_v_i(~(stall_v_i || bubble_v_i))
         ,.o(inst_r)
         );

   dff #(.width_p($bits(logic))
         )
  inst_v(.clk_i(clk_i)
         ,.rst_i(rst_i)
             
         ,.i(~bubble_v_i)
         ,.w_v_i(~(stall_v_i || bubble_v_i))
         ,.o(inst_v_r)
         );

always_comb begin
    inst_v_o = inst_v_r;
    inst_pc_o = inst_pc_r;
    inst_o = inst_r;
end

endmodule : ifid_latch
