`include "rvga_types.sv"
import rvga_types::*;

module test_ddr #(parameter use_program_p = 0
                  , use_identity_p = 0
                  , debug_p = 0
                  )
  ( input logic clk_i
	, input logic rst_i
	
	, input logic r_v_i
	, input logic w_v_i
	, input rvga_word addr_i
	, output rvga_word data_o
	, input rvga_word data_i
	, output logic resp_v_o
);

localparam ELF_SIZE=10000;

logic[7:0] mem_array[0:ELF_SIZE-1];

initial begin
  if(use_program_p) begin
    $readmemh("test_memory.mem", mem_array);
    
    $display("---------------- BEGIN MEMORY DUMP ----------------\n");
    for(integer i = 0; i < 100; i=i+4) begin
      $display("ADDR: %x DATA: %x\n", i, {mem_array[i+3],mem_array[i+2],mem_array[i+1],mem_array[i+0]});
    end
    $display("---------------- END MEMORY DUMP ----------------\n");
  end 
  else if(use_identity_p) begin
    for(integer i = 0; i < ELF_SIZE; i=i+1) begin
      mem_array[i] = i;
    end
  end
end

always_comb begin  
  data_o = {mem_array[addr_i+3], mem_array[addr_i+2], mem_array[addr_i+1], mem_array[addr_i+0]};
  resp_v_o = (r_v_i | w_v_i);
end

always_ff @(posedge clk_i) begin
  if(w_v_i) begin
    mem_array[addr_i+0] <= data_i[7:0];
    mem_array[addr_i+1] <= data_i[15:0];
    mem_array[addr_i+2] <= data_i[23:0];
    mem_array[addr_i+3] <= data_i[31:0];
  end
end

always_ff @(posedge clk_i) begin
  if(debug_p) begin
    if(r_v_i) begin
      $display("READ MEM[%x] (%x)\n", addr_i, data_o);             
    end else if(w_v_i) begin
      $display("WRITE MEM[%x] = (%x)\n", addr_i, data_i);
    end
  end
end

endmodule : test_ddr

