module execute_ctl 
  ( input logic stall_v_i
    , input logic flush_v_i
    
    , output logic cmux_sel_o
    , output logic cword_w_v_o
    
    , input logic dmem_r_v_i
    , input logic dmem_w_v_i
    , input logic imm_v_i
    , input logic addpc_v_i
              
    , input logic forward_memory_execute_rs1_v_i
    , input logic forward_memory_execute_rs2_v_i
    , input logic forward_writeback_execute_rs1_v_i
    , input logic forward_writeback_execute_rs2_v_i   
    
    , output logic[1:0] amux_sel_o
    , output logic[1:0] bmux_sel_o
    
    , output logic add_override_v_o
    );


always_comb begin
  cword_w_v_o = ~stall_v_i;
  cmux_sel_o = flush_v_i;
  
  if(addpc_v_i) begin
    amux_sel_o = 2'b01;
  end else if(forward_memory_execute_rs1_v_i) begin
    amux_sel_o = 2'b10;
  end else if(forward_writeback_execute_rs1_v_i) begin
    amux_sel_o = 2'b11;
  end else begin
    amux_sel_o = 2'b00;
  end
  
  if(imm_v_i) begin
    bmux_sel_o = 2'b01;
  end else if(forward_memory_execute_rs2_v_i) begin
    bmux_sel_o = 2'b10; 
  end else if(forward_writeback_execute_rs2_v_i) begin
    bmux_sel_o = 2'b11;
  end else begin
    bmux_sel_o = 2'b00;
  end
  
  add_override_v_o = dmem_r_v_i || dmem_w_v_i;
end


endmodule : execute_ctl

