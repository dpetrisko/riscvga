import rvga_types::*;

module array #(parameter width_p = 128 
               , parameter height_p = 8)
  ( input clk_i
    , input w_v_i
    , input logic[$clog2(height_p)-1:0] index_i
    , input [width_p-1:0] data_i
    , output logic [width_p-1:0] data_o
    );

logic [width_p-1:0] data [height_p-1:0];

always_ff @(posedge clk_i) begin
  if(w_v_i) begin
    data[index_i] <= data_i;
  end
end

always_comb begin
  data_o = data[index_i];
end
											    
endmodule : array
