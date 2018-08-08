import rvga_types::*;

module forwarding
  ( input logic memory_rd_w_v_i
    , input rvga_reg memory_rd_i

    , input logic writeback_rd_w_v_i
    , input rvga_reg writeback_rd_i

    , input rvga_reg execute_rs1_i
    , input rvga_reg execute_rs2_i
    
    , input logic execute_rs1_v_i
    , input logic execute_rs2_v_i
    
    , output logic forward_memory_execute_rs1_v_o
    , output logic forward_memory_execute_rs2_v_o
    
    , output logic forward_writeback_execute_rs1_v_o
    , output logic forward_writeback_execute_rs2_v_o
  );
  
always_comb begin
  forward_memory_execute_rs1_v_o = execute_rs1_v_i && (memory_rd_w_v_i && (memory_rd_i == execute_rs1_i) && (memory_rd_i != 0));
  forward_memory_execute_rs2_v_o = execute_rs2_v_i && (memory_rd_w_v_i && (memory_rd_i == execute_rs2_i) && (memory_rd_i != 0));
  
  forward_writeback_execute_rs1_v_o = execute_rs1_v_i && (writeback_rd_w_v_i && (writeback_rd_i == execute_rs1_i) && (writeback_rd_i != 0));
  forward_writeback_execute_rs2_v_o = execute_rs2_v_i && (writeback_rd_w_v_i && (writeback_rd_i == execute_rs2_i) && (writeback_rd_i != 0));
end

endmodule : forwarding
