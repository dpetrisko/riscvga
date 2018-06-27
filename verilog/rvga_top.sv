`include "rvga_types.sv"
import rvga_types::*;

module rvga_top #()
(
    input logic clk_i
    , input logic rst_i
    
    , output rvga_word imem_addr_o
    , input rvga_word imem_data_i
    , input logic imem_resp_v_i
    
	, output logic dmem_r_v_o
    , output logic dmem_w_v_o
    , output rvga_word dmem_addr_o
    , input rvga_word dmem_data_i
    , output rvga_word dmem_data_o
    , input logic dmem_resp_v_i
);

rvga_word ir;

  ifetch_stage ifetch(.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      ,.imem_addr_o(imem_addr_o)
                      ,.imem_data_i(imem_data_i)
                      ,.imem_resp_v_i(imem_resp_v_i)
                      
                      ,.ir_o(ir)
                      ,.br_tgt_i('0)
                      ,.br_v_i('0)
                      );
    
  decode_stage decode(.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      );
    
  rfetch_stage rfetch(.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      );
    
  execute_stage execute(.clk_i(clk_i)
                        ,.rst_i(rst_i)
                        );
    
  memory_stage memory(.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      ,.*
                      );
    
  writeback_stage writeback(.clk_i(clk_i)
                            ,.rst_i(rst_i)
                            ,.*
                            );

endmodule : rvga_top
