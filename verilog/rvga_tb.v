`include "debug_defines.vh"
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
    $dumpvars(0, imemory);
    $dumpvars(0, dmemory);
end

always @(posedge clk) begin
    `ifdef RF_DEBUG
    `endif
end

always @(posedge iddr_resp) begin
    `ifdef IMEM_DEBUG
    $display("CYCLE: %d, PC: %h, INST %b%b%b%b %b%b%b%b %b%b%b%b %b%b%b%b %b%b%b%b %b%b%b%b %b%b%b%b %b%b%b%b", cycle, iddr_addr, iddr_rdata[31], iddr_rdata[30], iddr_rdata[29], iddr_rdata[28], iddr_rdata[27], iddr_rdata[26], iddr_rdata[25], iddr_rdata[24], iddr_rdata[23], iddr_rdata[22], iddr_rdata[21], iddr_rdata[20], iddr_rdata[19], iddr_rdata[18], iddr_rdata[17], iddr_rdata[16], iddr_rdata[15], iddr_rdata[14], iddr_rdata[13], iddr_rdata[12], iddr_rdata[11], iddr_rdata[10], iddr_rdata[9], iddr_rdata[8], iddr_rdata[7], iddr_rdata[6], iddr_rdata[5], iddr_rdata[4], iddr_rdata[3], iddr_rdata[2], iddr_rdata[1], iddr_rdata[0]);
    `endif
end

always @(posedge dddr_resp) begin
	`ifdef DMEM_DEBUG
    if(dddr_read) begin
		$display("CYCLE: %d, DMEM READ  - ADDR: %h DATA %h", cycle, dddr_addr, dddr_rdata);
	end
	
	if(dddr_wdata) begin
		$display("CYCLE: %d, DMEM WRITE - ADDR: %h DATA %h", cycle, dddr_addr, dddr_wdata);
	end
    `endif
end

integer cycle = 0;

initial begin
	clk = 0;
	rst_n = 0;
	#12 rst_n = 1;
end

integer i;
always begin 
	#5 clk = ~clk; 
	cycle = cycle + 1;

    if(cycle >= 1000) begin
        $display("FINAL REGFILE: ");
        for(i = 0; i < 32; i=i+1) begin
            $display("R%d DEC:%d HEX:%x", i, $signed(processor.rfetch.regfile[i]), processor.rfetch.regfile[i]);
        end
        $write("\n");
        $finish;
    end
end

endmodule 


