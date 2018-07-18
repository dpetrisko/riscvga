module memory_dp #()
  ( input logic clk_i
    , input logic rst_i
    
    , output rvga_word dmem_addr_o
    , input rvga_word dmem_data_i
    , output rvga_word dmem_data_o
    );
    
always_comb begin
  dmem_addr_o = '0;
  dmem_data_o = '0;
end

endmodule : memory_dp

