`include "rvga_types.svh"

module writeback_stage
  ( input logic clk
    , input logic rst
    
    , output logic writeback_hazard_pc_redirect
    
    , output rvga_word writeback_ifetch_pc_target
    , output logic writeback_ifetch_pc_redirect
    );

always_ff @(posedge clk) begin

end

always_comb begin
  writeback_ifetch_pc_target = 0;
  writeback_ifetch_pc_redirect = 0;
end

endmodule : writeback_stage
