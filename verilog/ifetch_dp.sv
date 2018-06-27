module ifetch_dp
  ( input logic clk_i
    , input logic rst_i
    
    , output rvga_word imem_addr_o
    , input rvga_word imem_data_i
    
    , input rvga_word br_tgt_i
    
    , input logic pc_w_v_i
    , input logic ir_w_v_i
    , input logic pcmux_sel_i
    
    , output rvga_word ir_o
    );
    
rvga_word pc_r, pc_n;
rvga_word ir_r;
rvga_word pc_plus4;
   
dff #(.width_p($bits(rvga_word))
      )
 pc(.clk_i(clk_i)
      ,.rst_i(rst_i)
      
      ,.i(pc_n)
      ,.w_v_i(pc_w_v_i)
      ,.o(pc_r)
      );
      
 mux #(.els_p(2)
       ,.width_p($bits(rvga_word))
       )
 pcmux(.sel_i(pcmux_sel_i)
       ,.i({br_tgt_i
            ,pc_plus4
            }
           )
       ,.o(pc_n)
       );
      
dff #(.width_p($bits(rvga_word))
      )
  ir(.clk_i(clk_i)
       ,.rst_i(rst_i)
       
       ,.i(imem_data_i)
       ,.w_v_i(ir_w_v_i)
       ,.o(ir_r)
       );
        
adder #(.width_p($bits(rvga_word))
        ) 
 pc_inc (.a_i(pc_r)
         ,.b_i(32'd4)
         ,.o(pc_plus4)
         );
         
assign imem_addr_o = pc_r;
assign ir_o = ir_r;

endmodule : ifetch_dp

