`include "rvga_types.sv"
import rvga_types::*;

module ifetch_stage
  (input logic clk_i
   , input logic rst_i
   
   , output rvga_word imem_addr_o
   , input rvga_word imem_data_i
   , input logic imem_resp_v_i
   
   , output rvga_word ir_o
   
   , input rvga_word br_tgt_i
   , input logic br_v_i
   );
   
logic pc_w_v;
logic ir_w_v;

logic pcmux_sel;
   
ifetch_ctl #()
         ctl(.imem_resp_v_i(imem_resp_v_i)
             
             ,.br_v_i(br_v_i)
    
             ,.pc_w_v_o(pc_w_v)
             ,.ir_w_v_o(ir_w_v)
             
             ,.pcmux_sel_o(pcmux_sel)
             );

ifetch_dp #() 
         dp(.clk_i(clk_i)
            ,.rst_i(rst_i)
    
            ,.imem_addr_o(imem_addr_o)
            ,.imem_data_i(imem_data_i)
            
            ,.br_tgt_i(br_tgt_i)
    
            ,.pc_w_v_i(pc_w_v)
            ,.ir_w_v_i(ir_w_v)
            
            ,.pcmux_sel_i(pcmux_sel)
    
            ,.ir_o(ir_o)
            );

endmodule : ifetch_stage
