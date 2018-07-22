module writeback_ctl #()
  ( input logic stall_v_i
    
    , output logic cword_w_v_o
    
    , input logic br_v_i
    , input logic jmp_v_i
    , input logic bru_result_i
    
    , input logic dmem_r_v_i
    , input logic dmem_w_v_i
    
    , output logic[1:0] rdmux_sel_o
    , output logic btaken_o
    );
    
always_comb begin
  cword_w_v_o = ~stall_v_i;
  
  if(dmem_r_v_i || dmem_w_v_i) begin
    rdmux_sel_o = 2'b10;
  end else if(jmp_v_i) begin
    rdmux_sel_o = 2'b01;
  end else begin
    rdmux_sel_o = 2'b00;
  end
  
  btaken_o = jmp_v_i || (br_v_i && bru_result_i);
end

endmodule : writeback_ctl

