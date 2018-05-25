`include "rvga_types.sv"
import rvga_types::*;

module rvga_tb;

timeunit 1ns;
timeprecision 1ns;

logic clk;
logic rst;

rvga_membus_if imembus();
rvga_membus_if dmembus();

rvga_top #(.enable_caches(0)) 
processor (.imembus_io(imembus)
           ,.dmembus_io(dmembus)
           ,.*);

test_ddr #(.use_program(1)
           ,.magic(1)
           )
     iddr (.clk(clk)
           ,.rst(rst)
    
           ,.membus_io(imembus)
           );

test_ddr #(.use_program(1)
           ,.magic(1)
           )
     dddr (.clk(clk)
           ,.rst(rst)
        
           ,.membus_io(dmembus)
           );

integer cycle = 0;

initial begin
  clk = 0;
  rst = 1;
  #12 rst = 0;
end

integer i;
always begin 
  #5 clk = ~clk; 
  cycle = cycle + 1;

  if(cycle >= 100000) begin
    $finish;
  end
end

endmodule 
