`include "rvga_types.svh"

module l1cache_tb;

timeunit 1ns;
timeprecision 1ns;

logic clk;
logic rst;

integer cycle = 0;

rvga_word core_l1cache_addr;
logic core_l1cache_read;
logic core_l1cache_write;
rvga_word l1cache_core_rdata;
rvga_word core_l1cache_wdata;
logic l1cache_core_resp;

rvga_word l1cache_ddr_addr;
logic l1cache_ddr_read;
logic l1cache_ddr_write;
rvga_cacheline ddr_l1cache_rdata;
rvga_cacheline l1cache_ddr_wdata;
logic ddr_l1cache_resp;


l1cache  #(.total_size_bytes(1024)
           ,.num_sets(4)
          )
     l1c (.clk(clk)
          ,.rst(rst)
        
          ,.core_l1cache_addr(core_l1cache_addr)
          ,.core_l1cache_read(core_l1cache_read)
          ,.core_l1cache_write(core_l1cache_write)
          ,.l1cache_core_rdata(l1cache_core_rdata)
          ,.core_l1cache_wdata(core_l1cache_wdata)
          ,.l1cache_core_resp(l1cache_core_resp)
        
          ,.l1cache_ddr_addr(l1cache_ddr_addr)
          ,.l1cache_ddr_read(l1cache_ddr_read)
          ,.l1cache_ddr_write(l1cache_ddr_write)
          ,.ddr_l1cache_rdata(ddr_l1cache_rdata)
          ,.l1cache_ddr_wdata(l1cache_ddr_wdata)
          ,.ddr_l1cache_resp(ddr_l1cache_resp)
          );

test_ddr #(.latency(5)
           ,.use_identity(1)
           )
      ddr (.clk(clk)
           ,.rst(rst)
            
           ,.ddr_addr(l1cache_ddr_addr)
           ,.ddr_read(l1cache_ddr_read)
           ,.ddr_rdata(ddr_l1cache_rdata)
           ,.ddr_write(l1cache_ddr_write)
           ,.ddr_wdata(l1cache_ddr_wdata)
           ,.ddr_resp(ddr_l1cache_resp)
           );

initial begin
  clk = 0;
  rst = 1;
  #2 rst = 0;
end

always begin
    #5 clk = ~clk; 
end

integer i;
always begin 
  #5
  for(integer i = 0; i < 10000; i=i+4) begin
    core_l1cache_addr = i;
    core_l1cache_read = 1;
    core_l1cache_write = 0;
    
    while(~l1cache_core_resp) begin
        #10 cycle = cycle + 1;
    end 
        #10 cycle = cycle + 1;

    assert(core_l1cache_addr == l1cache_core_rdata);
  end
  $finish;
end

endmodule
