module memory_dp #()
  ( input rvga_word alu_result_i
    , input rvga_word st_result_i
    
    , output rvga_word ld_result_o
  
    , output rvga_word dmem_addr_o
    , input rvga_word dmem_data_i
    , output rvga_word dmem_data_o
    );
    
always_comb begin
  dmem_addr_o = alu_result_i;
  dmem_data_o = st_result_i;
  
  ld_result_o = dmem_data_i;
end

endmodule : memory_dp

