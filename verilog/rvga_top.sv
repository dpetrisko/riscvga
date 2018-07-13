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

rvga_word pc;
rvga_word ir;

logic ifetch_stall_v;
logic ifetch_flush_v;
logic decode_stall_v;
logic decode_flush_v;
logic rfetch_stall_v;
logic rfetch_flush_v;
logic execute_stall_v;
logic execute_flush_v;
logic memory_stall_v;
logic memory_flush_v;
logic writeback_stall_v;

rvga_decode_cword decode_cword;
rvga_rfetch_cword rfetch_cword;
rvga_execute_cword execute_cword;
rvga_memory_cword memory_cword;
rvga_writeback_cword writeback_cword;

  ifetch_stage ifetch(.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      ,.imem_addr_o(imem_addr_o)
                      ,.imem_data_i(imem_data_i)
                      
                      ,.stall_v_i(ifetch_stall_v)
                      ,.flush_v_i(ifetch_flush_v)
                      
                      ,.pc_o(pc)
                      ,.ir_o(ir)
                      
                      ,.br_tgt_i('0)
                      ,.br_v_i('0)
                      );
    
  decode_stage decode(.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      
                      ,.stall_v_i(decode_stall_v)
                      ,.flush_v_i(decode_flush_v)
                      
                      ,.pc_i(pc)
                      ,.ir_i(ir)
                      
                      ,.cword_o(decode_cword)
                      );
    
  rfetch_stage rfetch(.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      
                      ,.stall_v_i(rfetch_stall_v)
                      ,.flush_v_i(rfetch_flush_v)
                      
                      ,.cword_i(decode_cword)
                      ,.cword_o(rfetch_cword)
                      );
                      
  execute_stage execute(.clk_i(clk_i)
                        ,.rst_i(rst_i)
                        
                        ,.stall_v_i(execute_stall_v)
                        ,.flush_v_i(execute_flush_v)
                        
                        ,.cword_i(rfetch_cword)
                        ,.cword_o(execute_cword)
                        );
    
  memory_stage memory(.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      
                      ,.stall_v_i(memory_stall_v)
                      ,.flush_v_i(memory_flush_v)
                      
                      ,.cword_i(execute_cword)
                      ,.cword_o(memory_cword)
                      
                      ,.dmem_r_v_o(dmem_r_v_o)
                      ,.dmem_w_v_o(dmem_w_v_o)
                      ,.dmem_addr_o(dmem_addr_o)
                      ,.dmem_data_i(dmem_data_i)
                      ,.dmem_data_o(dmem_data_o)
                      ,.dmem_resp_v_i(dmem_resp_v_i)
                      );
    
  writeback_stage writeback(.clk_i(clk_i)
                            ,.rst_i(rst_i)
                            
                            ,.stall_v_i(writeback_stall_v)
                            
                            ,.cword_i(memory_cword)
                            ,.cword_o(writeback_cword)
                            
                            ,.br_tgt_o()
                            ,.br_v_o()
                            );
                            
  hazard hazard(.imem_read_v_i('1)
                ,.imem_resp_v_i(imem_resp_v_i)
                ,.dmem_read_v_i(dmem_r_v_o)
                ,.dmem_resp_v_i(dmem_resp_v_i)
                
                ,.decode_br_v_i('0)
                ,.rfetch_br_v_i('0)
                ,.execute_br_v_i('0)
                ,.memory_br_v_i('0)
                ,.writeback_br_v_i('0)
                
                ,.ifetch_flush_v_o(ifetch_flush_v)
                ,.decode_flush_v_o(decode_flush_v)
                ,.rfetch_flush_v_o(rfetch_flush_v)
                ,.execute_flush_v_o(execute_flush_v)
                ,.memory_flush_v_o(memory_flush_v)
                
                ,.ifetch_stall_v_o(ifetch_stall_v)
                ,.decode_stall_v_o(decode_stall_v)
                ,.rfetch_stall_v_o(rfetch_stall_v)
                ,.execute_stall_v_o(execute_stall_v)
                ,.memory_stall_v_o(memory_stall_v)
                ,.writeback_stall_v_o(writeback_stall_v)
                ); 

endmodule : rvga_top
