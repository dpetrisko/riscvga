module rvga_nonsynth_rvtest_monitor #(parameter enable_p = 0)
  ( input integer cycle_i
    , input logic clk_i

    , input logic[31:0] addr_i
    , input logic[7:0]  data_i
    , input logic w_v_i
  );

logic[47:0] char_fifo;

always_ff @(posedge clk_i) begin
  if(enable_p) begin
    if(w_v_i && (addr_i == 'h10000000)) begin
      char_fifo[47:0] = {char_fifo[39:0], data_i};

      if(char_fifo[23:0] == "OK\n") begin
        $display("Cycle %d: RV_TEST OK!", cycle_i);
        $finish();
      end

      if(char_fifo[47:0] == "ERROR\n") begin
        $error("Cycle %d: RV_TEST FAIL!", cycle_i);
        $finish();
      end
    end
  end
end

endmodule : rvga_nonsynth_rvtest_monitor
