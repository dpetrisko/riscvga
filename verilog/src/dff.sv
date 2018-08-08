module dff #(parameter width_p = 1
             , parameter reset_val_p = 0)
  ( input logic clk_i
    , input logic rst_i

    , input logic[width_p-1:0] i
    , input logic w_v_i
    , output logic[width_p-1:0] o
    );
    
logic[width_p-1:0] data_r, data_n;

always_comb begin
  data_n = i;
  o = data_r;
end

always_ff @(posedge clk_i) begin
  if (rst_i) begin
    data_r <= reset_val_p;
  end else if(w_v_i) begin
    data_r <= data_n;
  end else begin
    data_r <= data_r;
  end
end

endmodule : dff

