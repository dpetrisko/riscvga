`include "rvga_types.svh"

module icache 
#(parameter total_size_bytes = (1 * 1024), 
            num_sets = 4, 
            line_size_bytes = 16, 
            word_size_bytes = 4)
(
    input logic clk,
    input logic rst,
    
    input rvga_word ifetch_icache_addr,
    input logic ifetch_icache_read,
    output rvga_word icache_ifetch_rdata,
    output logic icache_ifetch_resp,
    
    output rvga_word icache_iddr_addr,
    output logic icache_iddr_read,
    input rvga_word iddr_icache_rdata,
    input logic iddr_icache_resp
);

logic[num_sets-1:0] icache_load;
logic icache_hit;

icache_datapath #(.total_size_bytes(total_size_bytes), .num_sets(num_sets), .line_size_bytes(line_size_bytes), .word_size_bytes(word_size_bytes)) (.*);

icache_control #(.num_sets(num_sets)) (.*);

always_ff @(posedge clk) begin

end

endmodule : icache
