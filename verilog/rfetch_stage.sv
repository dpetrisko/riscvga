`include "rvga_types.sv"
import rvga_types::*;

module rfetch_stage
  (input logic clk_i
   , input logic rst_i
   
   , input logic stall_v_i
   , input logic flush_v_i
   
   , input rvga_decode_cword cword_i
   , output rvga_rfetch_cword cword_o
   );
   
logic cmux_sel;
logic cword_w_v;
   
rfetch_ctl #()
        ctl (.stall_v_i(stall_v_i)
             ,.flush_v_i(flush_v_i)
            
             ,.cmux_sel_o(cmux_sel)
             ,.cword_w_v_o(cword_w_v)
             );
            
rfetch_dp #()
        dp (.clk_i(clk_i)
            ,.rst_i(rst_i)
           
            ,.cmux_sel_i(cmux_sel)
            ,.cword_w_v_i(cword_w_v)
           
            ,.cword_o(cword_o)
           
            ,.pc_i(cword_i.pc)
            ,.opcode_i(cword_i.opcode)
            ,.rs1_i(cword_i.rs1)
            ,.rs2_i(cword_i.rs2)
            ,.rd_i(cword_i.rd)
            ,.funct3_i(cword_i.funct3)
            ,.funct7_i(cword_i.funct7)
            ,.br_v_i(cword_i.br_v)
            ,.rd_w_v_i(cword_i.rd_w_v)
           
            ,.writeback_rd_w_v_i('0)
            ,.writeback_rd_i('0)
            ,.writeback_rd_data_i('0)
            );

endmodule : rfetch_stage

