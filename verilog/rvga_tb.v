`include "rvga_types.vh"

module rvga_tb();

timeunit 1ns;
timeprecision 1ns;

logic clk;
logic rst_n;

logic[31:0] iddr_addr;
logic iddr_read;
logic[31:0] iddr_rdata;
logic iddr_write;
logic[31:0] iddr_wdata;
logic iddr_resp;

logic[31:0] dddr_addr;
logic dddr_read;
logic[31:0] dddr_rdata;
logic dddr_write;
logic[31:0] dddr_wdata;
logic dddr_resp;

rvga processor(.*);

test_ddr imemory
(
	.clk,
	.rst_n,
	
	.ddr_addr(iddr_addr),
	.ddr_read(iddr_read),
	.ddr_rdata(iddr_rdata),
	.ddr_write(iddr_write),
	.ddr_wdata(iddr_wdata),
	.ddr_resp(iddr_resp)
);

test_ddr dmemory
(
	.clk,
	.rst_n,
	
	.ddr_addr(dddr_addr),
	.ddr_read(dddr_read),
	.ddr_rdata(dddr_rdata),
	.ddr_write(dddr_write),
	.ddr_wdata(dddr_wdata),
	.ddr_resp(dddr_resp)
);

string dumpfile;
initial begin
    if (! $value$plusargs("dumpfile=%s", dumpfile)) begin
        $display("ERROR: please specify +dump=<filename> to run.");
        $finish;
    end
    $dumpfile(dumpfile);
    $dumpvars(0, processor);
end

always @(posedge iddr_resp) begin
	//$display("CYCLE: %h PC: %h, INST: %h", cycle, iddr_addr, iddr_rdata);
end

always @(posedge dddr_resp) begin
	if(dddr_read) begin
	//	$display("CYCLE: %h, MEM READ  - ADDR: %h DATA %h", cycle, dddr_addr, dddr_rdata);
	end
	
	if(dddr_wdata) begin
	//	$display("CYCLE: %h, MEM WRITE - ADDR: %h DATA %h", cycle, dddr_addr, dddr_wdata);
	end
end

integer cycle = 0;

initial begin
	clk = 0;
	rst_n = 0;
	#12 rst_n = 1;
end


always begin 
	#5 clk = ~clk; 
	cycle = cycle + 1;

    if(cycle >= 100000) begin
        $finish;
    end
end

endmodule 


