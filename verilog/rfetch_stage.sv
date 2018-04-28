`include "rvga_types.svh"

module rfetch_stage
  ( input logic clk
    , input logic rst
    
    , output logic rfetch_hazard_pc_redirect
    );

always_ff @(posedge clk) begin

end

always_comb begin
    rfetch_hazard_pc_redirect = 0;
end

endmodule : rfetch_stage
