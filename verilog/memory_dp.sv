module memory_dp #()
  ( input rvga_word alu_result_i
    , input rvga_word st_result_i
    
    , input logic[2:0] funct3_i
    , output rvga_word ld_result_o
  
    , output rvga_word dmem_addr_o
    , input rvga_word dmem_data_i
    , output rvga_word dmem_data_o
    );
    
always_comb begin
  dmem_addr_o = alu_result_i;
  dmem_data_o = st_result_i;
  
  case(funct3_i)
    e_rvga_ldop_lb : ld_result_o = {{24{dmem_data_i[7]}}, dmem_data_i[7:0]};
    e_rvga_ldop_lh : ld_result_o = {{16{dmem_data_i[15]}},dmem_data_i[15:0]};
    e_rvga_ldop_lw : ld_result_o = dmem_data_i[31:0];
    e_rvga_ldop_lbu: ld_result_o = {{24{'0}}, dmem_data_i[7:0]};
    e_rvga_ldop_lhu: ld_result_o = {{16{'0}}, dmem_data_i[15:0]};
    default: ld_result_o = '0;
  endcase
  
  case(funct3_i)
    e_rvga_strop_sb : dmem_data_o = {{24{st_result_i[7]}}, st_result_i[7:0]};
    e_rvga_strop_sh : dmem_data_o = {{16{st_result_i[15]}}, st_result_i[15:0]};
    e_rvga_strop_sw : dmem_data_o = st_result_i[31:0];
    default: dmem_data_o = '0;
  endcase
end

endmodule : memory_dp

