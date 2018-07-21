module writeback_dp #()
  ( input logic br_v_i
    , input logic bru_result_i
    
    , output logic btaken_o
    );
    
always_comb begin
  btaken_o = (br_v_i && bru_result_i);
end

endmodule : writeback_dp

