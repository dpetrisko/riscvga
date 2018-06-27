`include "rvga_types.sv"
import rvga_types::*;

module rvga_tb;

logic clk;
logic rst;

rvga_top #() 
processor (.clk_i(clk)
           ,.rst_i(rst)
           ,.*);

test_ddr #(.use_program(1)
           ,.magic(1)
           )
     iddr (.clk(clk)
           ,.rst(rst)
           );

test_ddr #(.use_program(1)
           ,.magic(1)
           )
     dddr (.clk(clk)
           ,.rst(rst)
           );

integer cycle = 0;

initial begin
  clk = 0;
  rst = 1;
  #8 rst = 0;
end

always begin 
  #5 clk = ~clk; 
  cycle = cycle + 1;

  if(cycle >= 100000) begin
    $finish;
  end
end

endmodule 
