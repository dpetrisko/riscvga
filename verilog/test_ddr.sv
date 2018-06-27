`include "rvga_types.sv"
import rvga_types::*;

module test_ddr #(parameter use_program_p = 0
                  , use_identity_p = 0
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

rvga_word mem_array[0:ELF_SIZE-1];

initial begin
  if(use_program_p) begin
    $readmemh("test_memory.mem", mem_array);
  end 
  else if(use_identity_p) begin
    for(integer i = 0; i < ELF_SIZE; i=i+1) begin
      mem_array[i] = i;
    end
  end
end

always_comb begin  
  data_o = mem_array[addr_i];
  resp_v_o = 1'b1;
end

endmodule : test_ddr

