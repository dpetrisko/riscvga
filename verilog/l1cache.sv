`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

module l1cache #(parameter total_size_bytes = (8 * 1024)
                 , parameter num_sets = 4)
  ( input logic clk
    , input logic rst
    
    , rvga_cachebus_if.slave cachebus_io
    , rvga_membus_if.master membus_io
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
                  
                  ,.core_l1cache_addr(cachebus_io.addr_i)
                  ,.l1cache_core_rdata(cachebus_io.rdata_o)
                  ,.core_l1cache_wdata(cachebus_io.wdata_i)
                  
                  ,.l1cache_ddr_addr(membus_io.addr_o)
                  ,.ddr_l1cache_rdata(membus_io.rdata_i)
                  ,.l1cache_ddr_wdata(membus_io.wdata_o)
                  
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
                
                ,.core_l1cache_read(cachebus_io.read_i)
                ,.core_l1cache_write(cachebus_io.write_i)
                ,.l1cache_core_resp(cachebus_io.resp_o)
                
                ,.l1cache_ddr_read(membus_io.read_o)
                ,.l1cache_ddr_write(membus_io.write_o)
                ,.ddr_l1cache_resp(membus_io.resp_i)
                
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
