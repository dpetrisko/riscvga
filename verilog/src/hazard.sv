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
    
    , output logic hazard_stall_v_o
    
    , output logic bubble_v_o
    );
    
always_comb begin
  hazard_stall_v_o = (imem_read_v_i && ~imem_resp_v_i) || (dmem_read_v_i && ~dmem_resp_v_i);

  bubble_v_o = decode_br_v_i || rfetch_br_v_i || execute_br_v_i || memory_br_v_i;
end
    
endmodule : hazard

