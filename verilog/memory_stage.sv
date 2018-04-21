`include "rvga_types.svh"

module memory_stage
  ( input logic clk
    , input logic rst
    
    , output rvga_word memory_dcache_addr
    , output logic memory_dcache_read
    , input rvga_word dcache_memory_rdata
    , output logic memory_dcache_write
    , output rvga_word memory_dcache_wdata
    , input logic dcache_memory_resp
    );

always_ff @(posedge clk) begin

end

always_comb begin
  memory_dcache_addr = 0;
  memory_dcache_read = 0;
  memory_dcache_write = 0;
  memory_dcache_wdata = 0;
end

endmodule : memory_stage
