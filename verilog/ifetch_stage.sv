import rvga_types::*;

module ifetch_stage
  (input logic clk_i
   , input logic rst_i
   
   , output rvga_word imem_addr_o
   , input rvga_word imem_data_i
   
   , input logic stall_v_i
   , input logic bubble_v_i
   
   , output rvga_word pc_o
   , output logic inst_v_o
   , output rvga_word inst_o
   
   , input rvga_word btarget_i
   , input logic btaken_i
   );

rvga_word prev_pc_r, pc_r, pcmux_o;
rvga_word pc_plus4; 
   
dff #(.width_p($bits(rvga_word))
      )
 pc(.clk_i(clk_i)
      ,.rst_i(rst_i)
      
      ,.i(pcmux_o)
      ,.w_v_i(~(stall_v_i || (bubble_v_i && ~btaken_i)))
      ,.o(pc_r)
      );
      
   dff #(.width_p($bits(rvga_word))
         )
 prev_pc(.clk_i(clk_i)
         ,.rst_i(rst_i)
             
         ,.i(pc_r)
         ,.w_v_i(~(stall_v_i || (bubble_v_i && ~btaken_i)))
         ,.o(prev_pc_r)
         );
      
 mux #(.els_p(2)
       ,.width_p($bits(rvga_word))
       )
 pcmux(.sel_i(btaken_i)
       ,.i({btarget_i, pc_plus4})
       ,.o(pcmux_o)
       );
        
adder #(.width_p($bits(rvga_word))
        ) 
 pc_inc (.a_i(pc_r)
         ,.b_i(32'd4)
         ,.o(pc_plus4)
         );
         
always_comb begin
  imem_addr_o = pc_r;
  pc_o = prev_pc_r;
  
  inst_o = imem_data_i;
  inst_v_o = ~bubble_v_i;
end
endmodule : ifetch_stage
