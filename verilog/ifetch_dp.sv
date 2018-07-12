`include "rvga_types.sv"
import rvga_types::*;

module ifetch_dp
  ( input logic clk_i
    , input logic rst_i
    
    , output rvga_word imem_addr_o
    , input rvga_word imem_data_i
    
    , input rvga_word br_tgt_i
    
    , input logic pc_w_v_i
    , input logic ir_w_v_i
    , input logic pcmux_sel_i
    , input logic irmux_sel_i
    
    , output rvga_word pc_o
    , output rvga_word ir_o
    );
    
rvga_word pc_r, pcmux_o;
rvga_word ir_r, ir_n;
rvga_word pc_plus4;

rvga_word rvga_nop;
   
dff #(.width_p($bits(rvga_word))
      )
 pc(.clk_i(clk_i)
      ,.rst_i(rst_i)
      
      ,.i(pcmux_o)
      ,.w_v_i(pc_w_v_i)
      ,.o(pc_r)
      );
      
 mux #(.els_p(2)
       ,.width_p($bits(rvga_word))
       )
 pcmux(.sel_i(pcmux_sel_i)
       ,.i({br_tgt_i, pc_plus4})
       ,.o(pcmux_o)
       );
      
dff #(.width_p($bits(rvga_word))
      )
  ir(.clk_i(clk_i)
       ,.rst_i(rst_i)
       
       ,.i(ir_n)
       ,.w_v_i(ir_w_v_i)
       ,.o(ir_r)
       );
       
 mux #(.els_p(2)
       ,.width_p($bits(rvga_word))
       )
 irmux(.sel_i(irmux_sel_i)
       ,.i({rvga_nop, imem_data_i})
       ,.o(ir_n)
       );
        
adder #(.width_p($bits(rvga_word))
        ) 
 pc_inc (.a_i(pc_r)
         ,.b_i(32'd4)
         ,.o(pc_plus4)
         );
         
assign rvga_nop = 32'b0000_0000_0000_0000_0000_0000_0001_0011;
assign imem_addr_o = pc_r;
assign ir_o = ir_r;
assign pc_o = pc_r;

endmodule : ifetch_dp

