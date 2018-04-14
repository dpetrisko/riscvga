`include "rvga_types.svh"

module dcache
#(parameter total_size_bytes = (1 * 1024), 
            num_sets = 4, 
            line_size_bytes = 16, 
            word_size_bytes = 4)
(
    input logic clk,
    input logic rst,
    
    input rvga_word memory_dcache_addr,
    input logic memory_dcache_read,
    output rvga_word dcache_memory_rdata,
    input logic memory_dcache_write,
    input rvga_word memory_dcache_wdata,
    output logic dcache_memory_resp,
    
    output rvga_word dcache_dddr_addr,
    output logic dcache_dddr_read,
    input rvga_word dddr_dcache_rdata,
    output logic dcache_dddr_write,
    output rvga_word dcache_dddr_wdata,
    input logic dddr_dcache_resp
);

always_ff @(posedge clk) begin

end

always_comb begin

end

endmodule : dcache
