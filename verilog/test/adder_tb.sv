module adder_tb;

`timescale 1 ns / 1 ns

localparam width_lp = 16;

integer cycle = 0;

logic clk = 0;
logic [width_lp-1:0] test_input_a = 0;
logic [width_lp-1:0] test_input_b = 0;
logic [width_lp-1:0] expected_output, test_output;

  initial begin : clk_and_rst_generator
    clk = 0;
    forever begin
      #5 clk = ~clk;
    end
  end

  always_ff @(posedge clk) begin : generator
    test_input_a <= $random();
    test_input_b <= $random();

    cycle <= cycle + 1;
  end

  always_comb begin : scoreboard
    expected_output = test_input_a + test_input_b;
  end

  always_ff @(posedge clk) begin : monitor
      assert(test_output == expected_output);
  end

  adder #(.width_p(width_lp))
   dut (.a_i(test_input_a)
        ,.b_i(test_input_b)

        ,.o(test_output)
        );

endmodule : adder_tb
