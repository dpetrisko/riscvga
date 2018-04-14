`include "rvga_types.svh"

module rvga_tb();

timeunit 1ns;
timeprecision 1ns;

logic clk;
logic rst;

logic[31:0] ifetch_iddr_addr;
logic ifetch_iddr_read;
logic[31:0] iddr_ifetch_rdata;
logic iddr_ifetch_resp;

logic[31:0] memory_dddr_addr;
logic memory_dddr_read;
logic[31:0] dddr_memory_rdata;
logic memory_dddr_write;
logic[31:0] memory_dddr_wdata;
logic dddr_memory_resp;

rvga_top processor(.*);

test_ddr imemory
(
    .clk,
    .rst,
    
    .ddr_addr(ifetch_iddr_addr),
    .ddr_read(ifetch_iddr_read),
    .ddr_rdata(iddr_ifetch_rdata),
    .ddr_write(1'b0),
    .ddr_wdata(32'h0),
    .ddr_resp(iddr_ifetch_resp)
);

test_ddr dmemory
(
    .clk,
    .rst,

    .ddr_addr(memory_dddr_addr),
    .ddr_read(memory_dddr_read),
    .ddr_rdata(dddr_memory_rdata),
    .ddr_write(memory_dddr_write),
    .ddr_wdata(memory_dddr_wdata),
    .ddr_resp(dddr_memory_resp)
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

    if(cycle >= 100) begin
        $finish;
    end
end

endmodule 


