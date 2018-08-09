module dff_tb;

localparam width_lp = 16;
localparam reset_val_lp = 5;

integer cycle = 0;

logic clk = 0;
logic rst = 0;
logic w_v = 0;
logic [width_lp-1:0] p_test_input = 0;
logic p_rst = 0;
logic [width_lp-1:0] test_input = 0;
logic [width_lp-1:0] test_output;


  initial begin : clk_and_rst_generator
    clk = 0;
    forever begin
      #5 clk = ~clk;
    end
  end

  initial begin : rst_generator
    rst = 1;
    #15 rst = 0;
  end

  always_ff @(posedge clk) begin : generator
    test_input <= $random();
    w_v <= $random() % 2;

    cycle <= cycle + 1;
  end

  always_ff @(posedge clk) begin : scoreboard
    p_rst <= rst;
    if(w_v && ~rst) begin
      p_test_input <= test_input;
    end
  end

  always_ff @(posedge clk) begin : monitor
      if(p_rst) begin
        assert (test_output == reset_val_lp);
      end else begin
        assert (test_output == p_test_input);
      end
  end

  dff #(.width_p(width_lp)
        ,.reset_val_p(reset_val_lp)
        )
   dut (.clk_i(clk)
        ,.rst_i(rst)
        
        ,.w_v_i(w_v)
        ,.i(test_input)
        ,.o(test_output)
        );

endmodule : dff_tb
