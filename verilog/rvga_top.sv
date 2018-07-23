`include "rvga_types.sv"
import rvga_types::*;

module rvga_top #()
(
    input logic clk_i
    , input logic rst_i
    
    /* Instruction cache interface */
    , output rvga_word imem_addr_o
    , input rvga_word imem_data_i
    , input logic imem_resp_v_i
    
    /* Data cache interface */
	, output logic dmem_r_v_o
    , output logic dmem_w_v_o
    , output rvga_word dmem_addr_o
    , input rvga_word dmem_data_i
    , output rvga_word dmem_data_o
    , input logic dmem_resp_v_i
    
    /* Debug Interface */
    , output rvga_debug_cword debug_cword_o
    , output logic debug_cword_v_o
);

rvga_word pc;
rvga_word ir;

logic ifetch_stall_v, decode_stall_v, rfetch_stall_v, execute_stall_v, memory_stall_v, writeback_stall_v;
logic ifetch_flush_v, decode_flush_v, rfetch_flush_v, execute_flush_v, memory_flush_v;
logic decode_br_v, rfetch_br_v, execute_br_v, memory_br_v, writeback_br_v;
logic forward_writeback_execute_rs1_v, forward_writeback_execute_rs2_v, forward_memory_execute_rs1_v, forward_memory_execute_rs2_v;

rvga_rfetch_cword rfetch_cword;
rvga_execute_cword execute_cword;
rvga_memory_cword memory_cword;
rvga_writeback_cword writeback_cword;
rvga_debug_cword debug_cword;

rvga_word writeback_br_tgt;
logic writeback_btaken;

rvga_reg writeback_rd;
rvga_word writeback_rd_data; 
logic writeback_rd_w_v;

  ifetch_stage ifetch(.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      ,.imem_addr_o(imem_addr_o)
                      ,.imem_data_i(imem_data_i)
                      
                      ,.stall_v_i(ifetch_stall_v)
                      ,.flush_v_i(ifetch_flush_v)
                      
                      ,.pc_o(pc)
                      ,.ir_o(ir)
                      
                      ,.br_tgt_i(writeback_br_tgt)
                      ,.btaken_i(writeback_btaken)
                      );
    
  decode_stage decode(.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      
                      ,.stall_v_i(decode_stall_v)
                      ,.flush_v_i(decode_flush_v)
                      
                      ,.pc_i(pc)
                      ,.ir_i(ir)
                      
                      ,.cword_o(rfetch_cword)
                      
                      ,.br_v_o(decode_br_v)
                      );
    
  rfetch_stage rfetch(.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      
                      ,.stall_v_i(rfetch_stall_v)
                      ,.flush_v_i(rfetch_flush_v)
                      
                      ,.cword_i(rfetch_cword)
                      ,.cword_o(execute_cword)
                      
                      ,.rd_i(writeback_rd)
                      ,.rd_data_i(writeback_rd_data) 
                      ,.rd_w_v_i(writeback_rd_w_v)
                      
                      ,.br_v_o(rfetch_br_v)
                      );
                      
  execute_stage execute(.clk_i(clk_i)
                        ,.rst_i(rst_i)
                        
                        ,.stall_v_i(execute_stall_v)
                        ,.flush_v_i(execute_flush_v)
                        
                        ,.cword_i(execute_cword)
                        ,.cword_o(memory_cword)
                                            
                        ,.forward_memory_execute_rs1_v_i(forward_memory_execute_rs1_v)
                        ,.forward_memory_execute_rs2_v_i(forward_memory_execute_rs2_v)
                        ,.forward_writeback_execute_rs1_v_i(forward_writeback_execute_rs1_v)
                        ,.forward_writeback_execute_rs2_v_i(forward_writeback_execute_rs2_v)                          
                           
                        ,.memory_rd_data_i(memory_cword.alu_or_ld_result)           
                        ,.writeback_rd_data_i(writeback_cword.alu_or_ld_result)        
                                                
                        ,.br_v_o(execute_br_v)
                        );
    
  memory_stage memory(.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      
                      ,.stall_v_i(memory_stall_v)
                      ,.flush_v_i(memory_flush_v)
                      
                      ,.cword_i(memory_cword)
                      ,.cword_o(writeback_cword)
                      
                      ,.dmem_r_v_o(dmem_r_v_o)
                      ,.dmem_w_v_o(dmem_w_v_o)
                      ,.dmem_addr_o(dmem_addr_o)
                      ,.dmem_data_i(dmem_data_i)
                      ,.dmem_data_o(dmem_data_o)
                      
                      ,.br_v_o(memory_br_v)
                      );
    
  writeback_stage writeback(.clk_i(clk_i)
                            ,.rst_i(rst_i)
                            
                            ,.stall_v_i(writeback_stall_v)
                            
                            ,.cword_i(writeback_cword)
                            ,.cword_o(debug_cword)
                            
                            ,.br_tgt_o(writeback_br_tgt)
                            ,.btaken_o(writeback_btaken)
                            
                            ,.rd_o(writeback_rd)
                            ,.rd_data_o(writeback_rd_data)
                            ,.rd_w_v_o(writeback_rd_w_v)
                            
                            ,.br_v_o(writeback_br_v)
                            );
                            
  hazard hazard(.imem_read_v_i('1)
                ,.imem_resp_v_i(imem_resp_v_i)
                ,.dmem_read_v_i(dmem_r_v_o)
                ,.dmem_resp_v_i(dmem_resp_v_i)
                
                ,.decode_br_v_i(decode_br_v)
                ,.rfetch_br_v_i(rfetch_br_v)
                ,.execute_br_v_i(execute_br_v)
                ,.memory_br_v_i(memory_br_v)
                ,.writeback_br_v_i(writeback_br_v)
                
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
                
  forwarding #()
    forward(.memory_rd_w_v_i(memory_cword.rd_w_v)
            ,.memory_rd_i(memory_cword.rd)
                
            ,.writeback_rd_w_v_i(writeback_cword.rd_w_v)
            ,.writeback_rd_i(writeback_cword.rd)
                
            ,.execute_rs1_i(execute_cword.rs1)
            ,.execute_rs2_i(execute_cword.rs2)
                    
            ,.forward_memory_execute_rs1_v_o(forward_memory_execute_rs1_v)
            ,.forward_memory_execute_rs2_v_o(forward_memory_execute_rs2_v)
                    
            ,.forward_writeback_execute_rs1_v_o(forward_writeback_execute_rs1_v)
            ,.forward_writeback_execute_rs2_v_o(forward_writeback_execute_rs2_v)
            );

assign debug_cword_o = debug_cword;
assign debug_cword_v_o = debug_cword.v & (~writeback_stall_v);

endmodule : rvga_top
