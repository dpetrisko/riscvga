module memory_ctl #()
  ( input logic stall_v_i
    , input logic flush_v_i
    
    , output logic cmux_sel_o
    , output logic cword_w_v_o
    
    , output logic dmem_r_v_o
    , output logic dmem_w_v_o
    , input logic dmem_resp_v_i
    );
    
always_comb begin
  cword_w_v_o = ~stall_v_i;
  
  cmux_sel_o = flush_v_i;
  
  dmem_r_v_o = '0;
  dmem_w_v_o = '0;
end

endmodule : memory_ctl
