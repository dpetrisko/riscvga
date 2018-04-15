`include "rvga_types.svh"

module rvga_tb();

timeunit 1ns;
timeprecision 1ns;

logic clk;
logic rst;

logic[31:0] icache_iddr_addr;
logic icache_iddr_read;
logic[31:0] iddr_icache_rdata;
logic iddr_icache_resp;

logic[31:0] dcache_dddr_addr;
logic dcache_dddr_read;
logic[31:0] dddr_dcache_rdata;
logic dcache_dddr_write;
logic[31:0] dcache_dddr_wdata;
logic dddr_dcache_resp;

rvga_top processor(.*);

test_ddr iddr
(
    .clk,
    .rst,
    
    .ddr_addr(icache_iddr_addr),
    .ddr_read(icache_iddr_read),
    .ddr_rdata(iddr_icache_rdata),
    .ddr_write(1'b0),
    .ddr_wdata(32'h0),
    .ddr_resp(iddr_icache_resp)
);

test_ddr dddr
(
    .clk,
    .rst,

    .ddr_addr(dcache_dddr_addr),
    .ddr_read(dcache_dddr_read),
    .ddr_rdata(dddr_dcache_rdata),
    .ddr_write(dcache_dddr_write),
    .ddr_wdata(dcache_dddr_wdata),
    .ddr_resp(dddr_dcache_resp)
);

integer cycle = 0;

initial begin
	clk = 0;
	rst = 1;
	#12 rst = 0;
end

integer i;
always begin 
	#5 clk = ~clk; 
	cycle = cycle + 1;

    if(cycle >= 1000) begin
        $finish;
    end
end

endmodule 


