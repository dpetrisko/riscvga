`include "rvga_types.svh"

module array #(parameter width = 128 
               , parameter height = 8)
  ( input clk
    , input load
    , input logic[$clog2(height)-1:0] index
    , input [width-1:0] data_in
    , output logic [width-1:0] data_out
    );

logic [width-1:0] data [height-1:0];

initial begin
  for(integer i = 0; i < height; i=i+1) begin
      data[i] = 0;
  end
end

always_ff @(posedge clk) begin
  if(load) begin
    data[index] = data_in;
  end
end

always_comb begin
  data_out = data[index];
end
											    
endmodule : array
