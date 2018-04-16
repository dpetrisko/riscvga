`include "rvga_types.svh"

module test_ddr
#(parameter latency = 100)
(
	input logic clk,
	input logic rst,
	
	input rvga_word ddr_addr,
	input logic ddr_read,
	output rvga_cacheline ddr_rdata,
	input logic ddr_write,
	input rvga_cacheline ddr_wdata,
	output logic ddr_resp
);

timeunit 1ns;
timeprecision 1ns;

localparam line_size_bytes = $bits(rvga_cacheline) / 8;

rvga_byte mem_array[0:ELF_SIZE-1];
rvga_word internal_addr;
logic ready;

assign internal_addr = {ddr_addr[$bits(rvga_word)-1:$clog2(line_size_bytes)], ddr_addr[$clog2(line_size_bytes)-1:0]};

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
				    for(integer i = 0; i < line_size_bytes; i=i+1) begin
					   mem_array[internal_addr+i] = ddr_wdata[(i+1)*8-1 -: 8];
					end
					ddr_resp = 1'b1;
				end else if(ddr_read) begin				
					for(integer i = 0; i < line_size_bytes; i=i+1) begin
					   ddr_rdata[(i+1)*8-1 -: 8] = mem_array[internal_addr+i];
					end
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

