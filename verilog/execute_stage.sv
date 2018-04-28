`include "rvga_types.svh"

module execute_stage
  ( input logic clk
    , input logic rst
    
    , output logic execute_hazard_pc_redirect
    );

always_ff @(posedge clk) begin

end

always_comb begin
    execute_hazard_pc_redirect = 0;
end

endmodule : execute_stage
