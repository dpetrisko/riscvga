`include "rvga_types.sv"
import rvga_types::*;

module l1cache_control
  ( input logic clk
    , input logic rst
    
    , input logic core_l1cache_read
    , input logic core_l1cache_write
    , output logic l1cache_core_resp
    
    , output logic l1cache_ddr_read
    , output logic l1cache_ddr_write
    , input logic ddr_l1cache_resp
    
    , input logic dp_ctl_cacheline_hit_lo
    , input logic dp_ctl_cacheline_dirty_lo
    , output logic ctl_dp_nmru_update_lo
    , output logic ctl_dp_cacheline_read_lo
    , output logic ctl_dp_cacheline_write_lo
    , output logic ctl_dp_cacheline_allocate_lo
    , output logic ctl_dp_dirtytag_sel_lo
    , output logic ctl_dp_cacheline_data_sel_lo
    );

enum {idle, allocate, writeback} state, next_state;

always_ff @(posedge clk) begin
  state <= next_state;
end

always_comb begin
  l1cache_core_resp = 1'b0;
  l1cache_ddr_read = 1'b0;
  l1cache_ddr_write = 1'b0;
  ctl_dp_nmru_update_lo = 1'b0;
  ctl_dp_dirtytag_sel_lo = 1'b0;
  ctl_dp_cacheline_data_sel_lo = 1'b0;
  ctl_dp_cacheline_read_lo = 1'b0;
  ctl_dp_cacheline_write_lo = 1'b0;
  ctl_dp_cacheline_allocate_lo = 1'b0;

  next_state = idle;

  case(state) 
    idle: begin
      if(dp_ctl_cacheline_hit_lo) begin
        ctl_dp_nmru_update_lo = 1'b1;
        ctl_dp_cacheline_read_lo = core_l1cache_read;
        ctl_dp_cacheline_write_lo = core_l1cache_write;
        l1cache_core_resp = 1'b1;
      end 
      else if(dp_ctl_cacheline_dirty_lo) begin
        l1cache_ddr_write = 1'b1;
        ctl_dp_dirtytag_sel_lo = 1'b1;
        next_state = writeback;
      end 
      else begin
        l1cache_ddr_read = 1'b1;
        ctl_dp_cacheline_data_sel_lo = 1'b1;
        next_state = allocate;
      end
    end
        
    allocate: begin
        if((core_l1cache_read || core_l1cache_write) && ~ddr_l1cache_resp) begin
            l1cache_ddr_read = 1'b1;
            ctl_dp_cacheline_data_sel_lo = 1'b1;
            next_state = allocate;
        end 
        else if((core_l1cache_read || core_l1cache_write) && ddr_l1cache_resp) begin
            ctl_dp_cacheline_data_sel_lo = 1'b1;
            ctl_dp_cacheline_allocate_lo = 1'b1; 
        end
    end
    
    writeback: begin
      if((core_l1cache_read || core_l1cache_write) && ~ddr_l1cache_resp) begin
        l1cache_ddr_write = 1'b1;
        ctl_dp_dirtytag_sel_lo = 1'b1;
        next_state = writeback;
      end 
      else if((core_l1cache_read || core_l1cache_write) && ddr_l1cache_resp) begin
        l1cache_ddr_read = 1'b1;
        ctl_dp_cacheline_data_sel_lo = 1'b1;
        next_state = allocate;
      end
    end
  endcase
end

endmodule : l1cache_control
