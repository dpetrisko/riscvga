`include "rvga_types.sv"
import rvga_types::*;

module hazard
  ( input logic imem_read_v_i
    , input logic imem_resp_v_i
    , input logic dmem_read_v_i
    , input logic dmem_resp_v_i
    
    , input logic decode_br_v_i
    , input logic rfetch_br_v_i
    , input logic execute_br_v_i
    , input logic memory_br_v_i
    , input logic writeback_br_v_i
    
    , output logic ifetch_stall_v_o
    , output logic decode_stall_v_o
    , output logic rfetch_stall_v_o
    , output logic execute_stall_v_o
    , output logic memory_stall_v_o
    , output logic writeback_stall_v_o
    
    , output logic ifetch_flush_v_o
    , output logic decode_flush_v_o
    , output logic rfetch_flush_v_o
    , output logic execute_flush_v_o
    , output logic memory_flush_v_o
    );
    
always_comb begin
  ifetch_stall_v_o = (imem_read_v_i && ~imem_resp_v_i) || (dmem_read_v_i && ~dmem_resp_v_i);
  decode_stall_v_o = (imem_read_v_i && ~imem_resp_v_i) || (dmem_read_v_i && ~dmem_resp_v_i);
  rfetch_stall_v_o = (imem_read_v_i && ~imem_resp_v_i) || (dmem_read_v_i && ~dmem_resp_v_i);
  execute_stall_v_o = (imem_read_v_i && ~imem_resp_v_i) || (dmem_read_v_i && ~dmem_resp_v_i);
  memory_stall_v_o = (imem_read_v_i && ~imem_resp_v_i) || (dmem_read_v_i && ~dmem_resp_v_i);  
  writeback_stall_v_o = (imem_read_v_i && ~imem_resp_v_i) || (dmem_read_v_i && ~dmem_resp_v_i);

  ifetch_flush_v_o = decode_br_v_i;
  decode_flush_v_o = rfetch_br_v_i; 
  rfetch_flush_v_o = execute_br_v_i;
  execute_flush_v_o = memory_br_v_i;
  memory_flush_v_o = writeback_br_v_i;
end
    
endmodule : hazard

