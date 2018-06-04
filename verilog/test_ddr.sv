`include "rvga_types.sv"
import rvga_types::*;

module test_ddr #(parameter latency = 0
                  , read_only = 0
                  , magic = 0
                  , use_program = 0
                  , use_identity = 0)
  ( input logic clk
	, input logic rst
	
	, rvga_membus_if.slave membus_io
);

timeunit 1ns;
timeprecision 1ns;

localparam line_size_bytes = $bits(rvga_cacheline) / 8;
localparam ELF_SIZE=10000;

rvga_byte mem_array[0:ELF_SIZE-1];
rvga_word internal_addr;
logic ready;

assign internal_addr = {membus_io.addr_i[$bits(rvga_word)-1:$clog2(line_size_bytes)], membus_io.addr_i[$clog2(line_size_bytes)-1:0]};

enum int unsigned { idle, busy, respond } state, next_state;

initial begin
  if(use_program) begin
    $readmemh("test_memory.mem", mem_array);
  end 
  else if(use_identity) begin
    for(integer i = 0; i < ELF_SIZE; i=i+4) begin
      mem_array[i] = i[0 +: 8];
      mem_array[i+1] = i[8 +: 8];
      mem_array[i+2] = i[16 +: 8];
      mem_array[i+3] = i[24 +: 8];
    end
  end
end

always @(posedge clk) begin
  membus_io.resp_o = 1'b0;
  
  if(magic) begin
    if (rst) begin
      membus_io.rdata_o = '0;
    end else begin
      for(integer i = 0; i < line_size_bytes; i=i+1) begin
        membus_io.rdata_o[(i+1)*8-1 -: 8] = mem_array[internal_addr+i];
      end
    end
    membus_io.resp_o = 1'b1;
  end else begin 
    next_state = state;
 
    case(state)
      idle: begin
        if(membus_io.read_i | membus_io.write_i) begin
          next_state = busy;
          ready <= #latency 1'b1;
        end
      end
    
      busy: begin
        if (ready) begin
          if(membus_io.write_i) begin 
            for(integer i = 0; i < line_size_bytes; i=i+1) begin
              mem_array[internal_addr+i] = membus_io.wdata_i[(i+1)*8-1 -: 8];
            end
            membus_io.resp_o = 1'b1;
          end 
          else if(membus_io.read_i) begin				
            for(integer i = 0; i < line_size_bytes; i=i+1) begin
              membus_io.rdata_o[(i+1)*8-1 -: 8] = mem_array[internal_addr+i];
            end
              membus_io.resp_o = 1'b1;
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
end

always @(posedge clk)
begin : next_state_assignment
  state <= next_state;
end

endmodule : test_ddr

