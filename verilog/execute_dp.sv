`include "rvga_types.sv"
import rvga_types::*;

module execute_dp #()
  ( input logic amux_sel_i
    , input logic bmux_sel_i
    
    , input rvga_funct3 op_i
    , input logic alu_alt_i
    , input logic alu_ldst_v_i
    , input rvga_word imm_i
    , input rvga_word rs1_data_i
    , input rvga_word rs2_data_i
    
    , output rvga_word alu_result_o
    , output logic bru_result_o
    );

rvga_execute_cword cword_n, cword_r, cmux_o;

rvga_word amux_o, bmux_o, alu_o;
        
mux #(.els_p(2)
      ,.width_p($bits(rvga_word))
      )
amux (.sel_i(amux_sel_i)
      ,.i({'0, rs1_data_i})
      ,.o({amux_o})
      );
      
mux #(.els_p(2)
      ,.width_p($bits(rvga_word))            
      )
bmux (.sel_i(bmux_sel_i)
      ,.i({imm_i, rs2_data_i})
      ,.o({bmux_o})
      );

rvga_alu #()
      alu (.a_i(amux_o)
           ,.b_i(bmux_o)
           ,.op_i(op_i)
           ,.alt_i(alu_alt_i)
           ,.ldst_v_i(alu_ldst_v_i)
           
           ,.o(alu_result_o)
           );
           
 rvga_bru #()
       bru (.a_i(amux_o)
            ,.b_i(bmux_o)
            ,.op_i(op_i)
            
            ,.o(bru_result_o)
            );

endmodule : execute_dp

