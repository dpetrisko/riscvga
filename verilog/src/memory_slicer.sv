import rvga_types::*;

module memory_slicer
  ( input rvga_word ld_data_i
    , input rvga_word st_data_i
    
    , input rvga_funct3 op_i
    
    , output rvga_wmask wmask_o
    , output rvga_word  ld_result_o
    , output rvga_word  st_result_o
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
    e_rvga_strop_sb : begin 
                        st_result_o = {{24{st_data_i[7]}}, st_data_i[7:0]};
                        wmask_o = 4'b0001;
                      end
    e_rvga_strop_sh : begin 
                        st_result_o = {{16{st_data_i[15]}}, st_data_i[15:0]};
                        wmask_o = 4'b0011;
                      end
    e_rvga_strop_sw : begin 
                        st_result_o = st_data_i[31:0];
                        wmask_o = 4'b1111;
                      end
    default:          begin 
                        st_result_o = '0;
                        wmask_o = '0;
                      end
  endcase
end

endmodule : memory_slicer

