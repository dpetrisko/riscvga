module writeback_ctl #()
  ( input logic stall_v_i
    
    , output logic cword_w_v_o
    );
    
always_comb begin
  cword_w_v_o = ~stall_v_i;
end

endmodule : writeback_ctl

