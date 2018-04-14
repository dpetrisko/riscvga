`include "rvga_types.svh"

module l1cache
(
    input logic clk,
    input logic rst,
    
    input rvga_word ifetch_l1_addr,
    input logic ifetch_l1_read,
    output rvga_word l1_ifetch_rdata,
    output logic iddr_ifetch_resp
);

always_ff @(posedge clk) begin

end

always_comb begin

end

endmodule : l1cache
