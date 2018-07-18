module execute_ctl #()
  ( input logic stall_v_i
    , input logic flush_v_i
    
    , output logic cmux_sel_o
    , output logic cword_w_v_o
    
    , input logic imm_v_i
    
    , output logic amux_sel_o
    , output logic bmux_sel_o
    );
    
always_comb begin
  cword_w_v_o = ~stall_v_i;
  
  cmux_sel_o = flush_v_i;
  
  amux_sel_o = '0;
  bmux_sel_o = imm_v_i;
end

endmodule : execute_ctl

