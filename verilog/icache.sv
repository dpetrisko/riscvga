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

localparam lines_per_set = total_size_bytes / (num_sets * line_size_bytes);
localparam index_bits = $clog2(lines_per_set);
localparam offset_bits = $clog2(line_size_bytes);
localparam valid_bits = 1;
localparam data_bits = word_size_bytes * 8;
localparam tag_bits = data_bits - index_bits - offset_bits;

logic[valid_bits-1:0] valid_array_data_in;
logic[data_bits-1:0] data_array_data_in;
logic[tag_bits-1:0] tag_array_data_in;

logic[valid_bits-1:0] valid_array_data_out[num_sets-1:0];
logic[data_bits-1:0] data_array_data_out[num_sets-1:0];
logic[tag_bits-1:0] tag_array_data_out[num_sets-1:0];

logic[tag_bits-1:0] tag;
logic[index_bits-1:0] index;
logic[offset_bits-1:0] offset;

logic hit_valid;
rvga_word hit_line_data;
rvga_word hit_word_data;

logic cache_line_load;

genvar i;
generate
    for(i = 0; i < num_sets; i=i+1) begin : arrays
        array #(.width(valid_bits), .height(lines_per_set)) valid_array
        (.clk,
         .load(cache_line_load),
         .index,
         .data_in(valid_array_data_in),
         .data_out(valid_array_data_out[i])
        );
        
        array #(.width(data_bits), .height(lines_per_set)) data_array
        (.clk,
         .load(cache_line_load),
         .index,
         .data_in(data_array_data_in),
         .data_out(data_array_data_out[i])
        );
        
        array #(.width(tag_bits), .height(lines_per_set)) tag_array
        (.clk,
         .load(cache_line_load),
         .index,
         .data_in(tag_array_data_in),
         .data_out(tag_array_data_out[i])
        );
    end
endgenerate

always_ff @(posedge clk) begin
        
end

always_comb begin
    tag = ifetch_icache_addr[tag_bits+index_bits+offset_bits-1 -: tag_bits];
    index = ifetch_icache_addr[index_bits+offset_bits-1 -: index_bits];
    offset = ifetch_icache_addr[offset_bits-1 -: offset_bits];
    
    valid_array_data_in = 1'b1;
    data_array_data_in = iddr_icache_rdata;
    tag_array_data_in = tag;
    
    hit_valid = 0;
    for(integer i = 0; i < num_sets; i=i+1) begin : hits
        if((tag == tag_array_data_out[i]) && (valid_array_data_out[i])) begin
            hit_valid = 1;
            hit_line_data = data_array_data_out[i];
        end
    end
    
    hit_word_data = hit_line_data[(offset+1)*data_bits-1 -: data_bits];
    
    icache_ifetch_rdata = hit_word_data;
    icache_ifetch_resp = (hit_valid && ifetch_icache_read);
    
    cache_line_load = 0;
end

endmodule : icache
