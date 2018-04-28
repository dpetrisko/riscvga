`include "rvga_types.sv"
import rvga_types::*;

module l1cache #(parameter total_size_bytes = (8 * 1024)
                 , parameter num_sets = 4)
  ( input logic clk
    , input logic rst
    
    , input rvga_word core_l1cache_addr
    , input logic core_l1cache_read
    , input logic core_l1cache_write
    , output rvga_word l1cache_core_rdata
    , input rvga_word core_l1cache_wdata
    , output logic l1cache_core_resp
    
    , output rvga_word l1cache_ddr_addr
    , output logic l1cache_ddr_read
    , output logic l1cache_ddr_write
    , input rvga_cacheline ddr_l1cache_rdata
    , output rvga_cacheline l1cache_ddr_wdata
    , input logic ddr_l1cache_resp
    );

logic dp_ctl_cacheline_hit_lo;
logic dp_ctl_cacheline_dirty_lo;
logic ctl_dp_nmru_update_lo;
logic ctl_dp_cacheline_read_lo;
logic ctl_dp_cacheline_write_lo;
logic ctl_dp_cacheline_allocate_lo;
logic ctl_dp_dirtytag_sel_lo;
logic ctl_dp_cacheline_data_sel_lo;

l1cache_datapath #(.total_size_bytes(total_size_bytes)
                   ,.num_sets(num_sets)
                  ) 
        datapath (.clk(clk)
                  ,.rst(rst)
                  
                  ,.core_l1cache_addr(core_l1cache_addr)
                  ,.l1cache_core_rdata(l1cache_core_rdata)
                  ,.core_l1cache_wdata(core_l1cache_wdata)
                  
                  ,.l1cache_ddr_addr(l1cache_ddr_addr)
                  ,.ddr_l1cache_rdata(ddr_l1cache_rdata)
                  ,.l1cache_ddr_wdata(l1cache_ddr_wdata)
                  
                  ,.dp_ctl_cacheline_hit_lo(dp_ctl_cacheline_hit_lo)
                  ,.dp_ctl_cacheline_dirty_lo(dp_ctl_cacheline_dirty_lo)
                  ,.ctl_dp_nmru_update_lo(ctl_dp_nmru_update_lo)
                  ,.ctl_dp_cacheline_read_lo(ctl_dp_cacheline_read_lo)
                  ,.ctl_dp_cacheline_write_lo(ctl_dp_cacheline_write_lo)
                  ,.ctl_dp_cacheline_allocate_lo(ctl_dp_cacheline_allocate_lo)
                  ,.ctl_dp_dirtytag_sel_lo(ctl_dp_dirtytag_sel_lo)
                  ,.ctl_dp_cacheline_data_sel_lo(ctl_dp_cacheline_data_sel_lo)
                  );

l1cache_control #(
                )
       control (.clk(clk)
                ,.rst(rst)
                
                ,.core_l1cache_read(core_l1cache_read)
                ,.core_l1cache_write(core_l1cache_write)
                ,.l1cache_core_resp(l1cache_core_resp)
                
                ,.l1cache_ddr_read(l1cache_ddr_read)
                ,.l1cache_ddr_write(l1cache_ddr_write)
                ,.ddr_l1cache_resp(ddr_l1cache_resp)
                
                ,.dp_ctl_cacheline_hit_lo(dp_ctl_cacheline_hit_lo)
                ,.dp_ctl_cacheline_dirty_lo(dp_ctl_cacheline_dirty_lo)
                ,.ctl_dp_nmru_update_lo(ctl_dp_nmru_update_lo)
                ,.ctl_dp_cacheline_read_lo(ctl_dp_cacheline_read_lo)
                ,.ctl_dp_cacheline_write_lo(ctl_dp_cacheline_write_lo)
                ,.ctl_dp_cacheline_allocate_lo(ctl_dp_cacheline_allocate_lo)
                ,.ctl_dp_dirtytag_sel_lo(ctl_dp_dirtytag_sel_lo)
                ,.ctl_dp_cacheline_data_sel_lo(ctl_dp_cacheline_data_sel_lo)
                );

always_ff @(posedge clk) begin

end

always_comb begin

end

endmodule : l1cache
