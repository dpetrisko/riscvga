import rvga_types::*;

module memory_slicer
  ( input rvga_word ld_data_i
    , input rvga_word st_data_i
    
    , input rvga_funct3 op_i
    
    , output rvga_word ld_result_o
    , output rvga_word st_result_o
   );

always_comb begin
  case(op_i)
    e_rvga_ldop_lb : ld_result_o = {{24{ld_data_i[7]}}, ld_data_i[7:0]};
    e_rvga_ldop_lh : ld_result_o = {{16{ld_data_i[15]}},ld_data_i[15:0]};
    e_rvga_ldop_lw : ld_result_o = ld_data_i[31:0];
    e_rvga_ldop_lbu: ld_result_o = {{24{'0}}, ld_data_i[7:0]};
    e_rvga_ldop_lhu: ld_result_o = {{16{'0}}, ld_data_i[15:0]};
    default: ld_result_o = '0;
  endcase
  
  case(op_i)
    e_rvga_strop_sb : st_result_o = {{24{st_data_i[7]}}, st_data_i[7:0]};
    e_rvga_strop_sh : st_result_o = {{16{st_data_i[15]}}, st_data_i[15:0]};
    e_rvga_strop_sw : st_result_o = st_data_i[31:0];
    default: st_result_o = '0;
  endcase
end

endmodule : memory_slicer

