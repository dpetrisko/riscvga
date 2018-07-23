`include "rvga_types.sv"
import rvga_types::*;

module execute_dp #()
  ( input logic[1:0] amux_sel_i
    , input logic[1:0] bmux_sel_i
    
    , input rvga_word pc_i
    , input rvga_funct3 op_i
    , input logic alu_alt_i
    , input logic alu_add_override_v_i
    , input rvga_word imm_i
    , input rvga_word rs1_data_i
    , input rvga_word rs2_data_i
    
    , output rvga_word alu_result_o
    , output logic bru_result_o
    
    , input rvga_word memory_rd_data_i
    , input rvga_word writeback_rd_data_i
    );

rvga_execute_cword cword_n, cword_r, cmux_o;

rvga_word amux_o, bmux_o, alu_o;
rvga_word rvga_zero;
        
mux #(.els_p(4)
      ,.width_p($bits(rvga_word))
      )
amux (.sel_i(amux_sel_i)
      ,.i({writeback_rd_data_i, memory_rd_data_i, pc_i, rs1_data_i})
      ,.o({amux_o})
      );
      
mux #(.els_p(4)
      ,.width_p($bits(rvga_word))            
      )
bmux (.sel_i(bmux_sel_i)
      ,.i({writeback_rd_data_i, memory_rd_data_i, imm_i, rs2_data_i})
      ,.o({bmux_o})
      );

rvga_alu #()
      alu (.a_i(amux_o)
           ,.b_i(bmux_o)
           ,.op_i(op_i)
           ,.alt_i(alu_alt_i)
           ,.add_override_v_i(alu_add_override_v_i)
           
           ,.o(alu_result_o)
           );
           
 rvga_bru #()
       bru (.a_i(amux_o)
            ,.b_i(bmux_o)
            ,.op_i(op_i)
            
            ,.o(bru_result_o)
            );
            
assign rvga_zero = '0;

endmodule : execute_dp

