`include "rvga_types.svh"

module l1cache_datapath #(parameter total_size_bytes = (8 * 1024) 
                          , parameter num_sets = 4)
  ( input logic clk
    , input logic rst
    
    , input rvga_word core_l1cache_addr
    , output rvga_word l1cache_core_rdata
    , input rvga_word core_l1cache_wdata
    
    , output rvga_word l1cache_ddr_addr
    , input rvga_cacheline ddr_l1cache_rdata
    , output rvga_cacheline l1cache_ddr_wdata
    
    , output logic dp_ctl_cacheline_hit_lo
    , output logic dp_ctl_cacheline_dirty_lo
    , input logic ctl_dp_nmru_update_lo
    , input logic ctl_dp_cacheline_read_lo
    , input logic ctl_dp_cacheline_write_lo
    , input logic ctl_dp_cacheline_allocate_lo
    , input logic ctl_dp_dirtytag_sel_lo
    , input logic ctl_dp_cacheline_data_sel_lo
    );

localparam byte_size_bits = 8;
localparam word_size_bits = $bits(rvga_word);
localparam word_size_bytes = $bits(rvga_word) / byte_size_bits;
localparam line_size_bits = $bits(rvga_cacheline);
localparam line_size_bytes = line_size_bits / byte_size_bits;
localparam words_per_line = line_size_bytes / word_size_bytes;
localparam lines_per_set = total_size_bytes / (num_sets * line_size_bytes);
localparam index_bits = $clog2(lines_per_set);
localparam offset_bits = $clog2(line_size_bytes);
localparam valid_bits = 1;
localparam dirty_bits = 1;

localparam tag_bits = word_size_bits - index_bits - offset_bits;

logic[valid_bits-1:0] valid_array_data_in[num_sets-1:0];
logic[line_size_bits-1:0] data_array_data_in[num_sets-1:0];
logic[tag_bits-1:0] tag_array_data_in[num_sets-1:0];
logic[dirty_bits-1:0] dirty_array_data_in[num_sets-1:0];

logic[valid_bits-1:0] valid_array_data_out[num_sets-1:0];
logic[line_size_bits-1:0] data_array_data_out[num_sets-1:0];
logic[tag_bits-1:0] tag_array_data_out[num_sets-1:0];
logic[dirty_bits-1:0] dirty_array_data_out[num_sets-1:0];

logic[tag_bits-1:0] tag;
logic[index_bits-1:0] index;
logic[offset_bits-1:0] offset;

logic[num_sets-1:0] hit_vector;
rvga_cacheline hit_line_data;
rvga_cacheline cacheline_data_in;
rvga_word hit_word_data;

logic cacheline_load[num_sets-1:0];
logic[num_sets-1:0] cache_replacement_select;

genvar i;
generate
  for(i = 0; i < num_sets; i=i+1) begin : arrays
    array #(.width(valid_bits) 
            ,.height(lines_per_set)
            ) 
     valid (.clk
             ,.load(cacheline_load[i])
             ,.index
             ,.data_in(valid_array_data_in[i])
             ,.data_out(valid_array_data_out[i])
             );
      
      array #(.width(line_size_bits)
              ,.height(lines_per_set)
              ) 
        data (.clk
              ,.load(cacheline_load[i])
              ,.index
              ,.data_in(data_array_data_in[i])
              ,.data_out(data_array_data_out[i])
              );
      
      array #(.width(tag_bits) 
              ,.height(lines_per_set)
              ) 
         tag (.clk
              ,.load(cacheline_load[i])
              ,.index
              ,.data_in(tag_array_data_in[i])
              ,.data_out(tag_array_data_out[i])
              );
      
      array #(.width(dirty_bits)
              ,.height(lines_per_set)
              ) 
       dirty (.clk
              ,.load(cacheline_load[i])
              ,.index
              ,.data_in(dirty_array_data_in[i])
              ,.data_out(dirty_array_data_out[i])
              );
    end
    
    nmru #(.num_sets(num_sets)
           ,.lines_per_set(lines_per_set)
           ) 
     nmru (.clk
           ,.rst
         
           ,.index_lo(index)
           ,.cache_replacement_update(ctl_dp_nmru_update_lo)
           ,.hit_vector
           ,.cache_replacement_select
           );
endgenerate

always_ff @(posedge clk) begin
        
end

always_comb begin
  tag = core_l1cache_addr[tag_bits+index_bits+offset_bits-1 -: tag_bits];
  index = core_l1cache_addr[index_bits+offset_bits-1 -: index_bits];
  offset = core_l1cache_addr[offset_bits-1 -: offset_bits];
  
  l1cache_ddr_addr = core_l1cache_addr;
  
  dp_ctl_cacheline_hit_lo = 0;
  hit_line_data = 0;
  hit_vector = 0;
  dp_ctl_cacheline_dirty_lo = dirty_array_data_out[cache_replacement_select];
  for(integer i = 0; i < num_sets; i=i+1) begin : hits
    if((tag == tag_array_data_out[i]) && (valid_array_data_out[i])) begin
      dp_ctl_cacheline_hit_lo = valid_array_data_out[i];
      dp_ctl_cacheline_dirty_lo = dirty_array_data_out[i];
      hit_vector[i] = 1;
      hit_line_data = data_array_data_out[i];
          
      if(ctl_dp_dirtytag_sel_lo) begin
        l1cache_ddr_addr[tag_bits-1:0] = tag_array_data_out[i];
      end
    end
  end
  
  cacheline_data_in = hit_line_data;
  for(integer i = 0; i < words_per_line; i=i+1) begin : cacheline_data
    if(i == (offset / word_size_bytes)) begin
      cacheline_data_in[(i)*word_size_bits +: word_size_bits] = core_l1cache_wdata;
    end
  end
  
  if(ctl_dp_cacheline_data_sel_lo) begin
    cacheline_data_in = ddr_l1cache_rdata;
  end

  for(integer i = 0; i < num_sets; i=i+1) begin : array_in      
    valid_array_data_in[i] = 1'b1;
    data_array_data_in[i] = cacheline_data_in;
    tag_array_data_in[i] = tag;
    dirty_array_data_in[i] = ~ctl_dp_cacheline_allocate_lo 
                             & (ctl_dp_cacheline_read_lo | ctl_dp_cacheline_write_lo);
      
    cacheline_load[i] = (ctl_dp_cacheline_write_lo & hit_vector[i])
                        | (ctl_dp_cacheline_allocate_lo & cache_replacement_select[i]);
  end
  
  hit_word_data = hit_line_data[(offset)*byte_size_bits +: word_size_bits];
  l1cache_core_rdata = hit_word_data;
  
  l1cache_ddr_wdata = 0;
  for(integer i = 0; i < num_sets; i=i+1) begin 
    if(cache_replacement_select[i]) begin
      l1cache_ddr_wdata = data_array_data_out[i];
    end
  end
end

endmodule : l1cache_datapath
