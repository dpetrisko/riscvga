`include "rvga_types.svh"

module test_ddr
(
	input logic clk,
	input logic rst,
	
	input rvga_word ddr_addr,
	input logic ddr_read,
	output rvga_word ddr_rdata,
	input logic ddr_write,
	input rvga_word ddr_wdata,
	output logic ddr_resp
);

timeunit 1ns;
timeprecision 1ns;

parameter latency = 0;

rvga_byte mem_array[0:ELF_SIZE-1];
rvga_word internal_addr;
logic ready;

assign internal_addr = ddr_addr & ~(32'h3);

enum int unsigned {
	idle,
	busy,
	respond
} state, next_state;

integer i;
initial begin
	$readmemh("test_memory.mem", mem_array);
end

always @(posedge clk) begin
	ddr_resp = 1'b0;
	
	next_state = state;
	
	case(state)
		idle: begin
			if(ddr_read | ddr_write) begin
				next_state = busy;
				ready <= #latency 1'b1;
			end
		end
		
		busy: begin
			if (ready) begin
				if(ddr_write) begin 
					mem_array[internal_addr+3] = ddr_wdata[31:24];
					mem_array[internal_addr+2] = ddr_wdata[23:16];
					mem_array[internal_addr+1] = ddr_wdata[15:8];
					mem_array[internal_addr+0] = ddr_wdata[7:0];
					ddr_resp = 1'b1;
				end else if(ddr_read) begin				
					ddr_rdata = { mem_array[internal_addr+3], mem_array[internal_addr+2], mem_array[internal_addr+1], mem_array[internal_addr+0] };
					ddr_resp = 1'b1;
				end
				
				next_state = respond;
			end
		end
		
		respond: begin
			ready <= 0;
			next_state = idle;
		end
		
		default: next_state = idle;
	endcase
end

always @(posedge clk)
begin : next_state_assignment
    state <= next_state;
end

endmodule 

