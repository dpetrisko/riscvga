module writeback_ctl #()
  ( input logic stall_v_i
    
    , output logic cword_w_v_o
    
    , input logic br_v_i
    , input logic jmp_v_i
    , input logic bru_result_i
    
    , output logic rdmux_sel_o
    , output logic btaken_o
    );
    
always_comb begin
  cword_w_v_o = ~stall_v_i;
  

end

endmodule : writeback_ctl

