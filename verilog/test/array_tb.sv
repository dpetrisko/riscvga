module array_tb;

`timescale 1 ns / 1 ns

localparam width_lp = 8;
localparam height_lp = 4;

integer cycle = 0;

logic clk = 0;
logic [$clog2(height_lp)-1:0] test_addr = 0;
logic [width_lp-1:0] test_data = 0;
logic w_v = 0;
logic [width_lp-1:0] test_output;

integer test_array[integer];

  initial begin : clk_and_rst_generator
    clk = 0;
    forever begin
      #5 clk = ~clk;
    end
  end

  always_ff @(posedge clk) begin : generator
    test_addr <= $random();
    test_data <= $random();
    w_v <= $random() / 2;

    cycle <= cycle + 1;
  end

  always_comb begin : scoreboard
    if(w_v) begin
      test_array[test_addr] = test_data;
    end
  end

  always_ff @(posedge clk) begin : monitor
    if(~w_v && test_array.exists(test_addr)) begin
      assert(test_array[test_addr] == test_output);
    end
  end

  array #(.width_p(width_lp)
          ,.height_p(height_lp)
          )
     dut (.clk_i(clk)
          ,.w_v_i(w_v)

          ,.index_i(test_addr)
          ,.data_i(test_data)
          ,.data_o(test_output)
          );

endmodule : array_tb
