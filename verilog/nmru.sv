`include "rvga_types.svh"

module nmru
#(parameter num_sets = 4, lines_per_set = 16)
(
    input logic clk,
    input logic rst,
    
    input logic[$clog2(lines_per_set)-1:0] index,
    input logic icache_replacement_update,
    input logic[num_sets-1:0] hit_vector,
    output logic[num_sets-1:0] icache_replacement_select
);

logic[num_sets-1:0] mru_array_data_in;
logic[num_sets-1:0] mru_array_data_out;

generate
    array #(.width(num_sets), .height(lines_per_set)) mru_array
    (.clk,
     
     .load(icache_replacement_update),
     .index,
     .data_in(mru_array_data_in),
     .data_out(mru_array_data_out)
    );
endgenerate


always_ff @(posedge clk) begin
    
end

always_comb begin
    mru_array_data_in = hit_vector; 
    
    icache_replacement_select = 1;
    for(integer i = 0; i < num_sets; i=i+1) begin
        if(mru_array_data_out[i]) begin
            icache_replacement_select = 1 << ((i+1)%num_sets);
        end
    end    
end

endmodule : nmru
