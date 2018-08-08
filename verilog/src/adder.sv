module adder #(parameter width_p = 1)
  ( input logic[width_p-1:0] a_i
    , input logic[width_p-1:0] b_i
    , output logic[width_p-1:0] o
    );

always_comb begin
  o = a_i + b_i;
end 

endmodule : adder

