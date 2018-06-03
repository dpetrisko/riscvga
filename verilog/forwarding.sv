`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

module forwarding
  ( input logic execute_rd_w_v
    , input rvga_reg execute_rd

    , input logic memory_rd_w_v
    , input rvga_reg memory_rd

    , input rvga_reg rfetch_rs1
    , input rvga_reg rfetch_rs2
    
    , output logic forwarding_execute_rs1_v
    , output logic forwarding_execute_rs2_v
    
    , output logic forwarding_memory_rs1_v
    , output logic forwarding_memory_rs2_v
  );
  
always_comb begin
  forwarding_execute_rs1_v = (execute_rd_w_v && (execute_rd == rfetch_rs1) && (execute_rd != 0));
  forwarding_execute_rs2_v = (execute_rd_w_v && (execute_rd == rfetch_rs2) && (execute_rd != 0));
  
  forwarding_memory_rs1_v = (memory_rd_w_v && (memory_rd == rfetch_rs1) && (memory_rd != 0));
  forwarding_memory_rs2_v = (memory_rd_w_v && (memory_rd == rfetch_rs2) && (memory_rd != 0));
end

endmodule : forwarding
