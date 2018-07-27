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
);

rvga_word pc;
rvga_word inst;
logic inst_v;

rvga_inst_type decode_inst_type;
logic[31:7] decode_imm_raw;
                      
rvga_word rfetch_imm_data;
rvga_word rfetch_rs1_data;
rvga_word rfetch_rs2_data;
rvga_word execute_st_data;

logic ifetch_stall_v, decode_stall_v, rfetch_stall_v, execute_stall_v, memory_stall_v, writeback_stall_v;
logic bubble_v;
logic forward_writeback_execute_rs1_v, forward_writeback_execute_rs2_v, forward_memory_execute_rs1_v, forward_memory_execute_rs2_v;
rvga_cword decode_cword, rfetch_cword, execute_cword, memory_cword, writeback_cword, debug_cword;
rvga_dword execute_dword, memory_dword, writeback_dword, debug_dword;
logic decode_br_v, rfetch_br_v, execute_br_v;

logic memory_btaken;

rvga_reg writeback_rd;
rvga_word memory_rd_data, writeback_rd_data; 
logic writeback_rd_w_v;

rvga_word execute_alu_result;
logic execute_bru_result;
rvga_word memory_alu_or_ld_result;
logic bru_result;

  ifetch_stage ifetch(.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      ,.imem_addr_o(imem_addr_o)
                      ,.imem_data_i(imem_data_i)
                      
                      ,.stall_v_i(ifetch_stall_v)
                      ,.bubble_v_i(bubble_v)
                      
                      ,.pc_o(pc)
                      ,.inst_v_o(inst_v)
                      ,.inst_o(inst)
                      
                      ,.btarget_i(memory_alu_or_ld_result)
                      ,.btaken_i(memory_btaken)
                      );
    
  decode_stage decode(.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      
                      ,.stall_v_i(decode_stall_v)
                      ,.bubble_v_i(bubble_v)
                      
                      ,.pc_i(pc)
                      ,.inst_v_i(inst_v)
                      ,.inst_i(inst)
                      
                      ,.cword_o(decode_cword)
                      
                      ,.imm_raw_o(decode_imm_raw)
                      ,.br_v_o(decode_br_v)
                      );
    
  rfetch_stage rfetch(.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      
                      ,.stall_v_i(rfetch_stall_v)
                      
                      ,.cword_i(decode_cword)
                      ,.cword_o(rfetch_cword)
                      
                      ,.rd_i(writeback_rd)
                      ,.rd_data_i(writeback_rd_data) 
                      ,.rd_w_v_i(writeback_rd_w_v)
                      
                      ,.imm_raw_i(decode_imm_raw)
                      
                      ,.imm_data_o(rfetch_imm_data)
                      ,.rs1_data_o(rfetch_rs1_data)
                      ,.rs2_data_o(rfetch_rs2_data)
                     
                      ,.br_v_o(rfetch_br_v)
                      );
                      
  execute_stage execute(.clk_i(clk_i)
                        ,.rst_i(rst_i)
                        
                        ,.stall_v_i(execute_stall_v)
                        
                        ,.cword_i(rfetch_cword)
                        ,.cword_o(execute_cword)
                                  
                        ,.dword_o(execute_dword)
                        
                        ,.imm_data_i(rfetch_imm_data)
                        ,.rs1_data_i(rfetch_rs1_data)
                        ,.rs2_data_i(rfetch_rs2_data)
                                            
                        ,.forward_memory_execute_rs1_v_i(forward_memory_execute_rs1_v)
                        ,.forward_memory_execute_rs2_v_i(forward_memory_execute_rs2_v)
                        ,.forward_writeback_execute_rs1_v_i(forward_writeback_execute_rs1_v)
                        ,.forward_writeback_execute_rs2_v_i(forward_writeback_execute_rs2_v)                          
                           
                        ,.memory_rd_data_i(memory_alu_or_ld_result)           
                        ,.writeback_rd_data_i(writeback_rd_data)   
                        
                        ,.alu_result_o(execute_alu_result)
                        ,.bru_result_o(execute_bru_result)  
                        ,.st_data_o(execute_st_data)
                         
                        ,.br_v_o(execute_br_v)
                        );
    
  memory_stage memory(.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      
                      ,.stall_v_i(memory_stall_v)
                      
                      ,.cword_i(execute_cword)
                      ,.cword_o(memory_cword)
           
                      ,.dword_i(execute_dword)           
                      ,.dword_o(memory_dword)
                      
                      ,.alu_result_i(execute_alu_result)
                      ,.bru_result_i(execute_bru_result)
                      ,.st_data_i(execute_st_data)
                      
                      ,.dmem_r_v_o(dmem_r_v_o)
                      ,.dmem_w_v_o(dmem_w_v_o)
                      ,.dmem_addr_o(dmem_addr_o)
                      ,.dmem_data_i(dmem_data_i)
                      ,.dmem_data_o(dmem_data_o)
                      
                      ,.btaken_o(memory_btaken)
                      ,.alu_or_ld_result_o(memory_alu_or_ld_result)
                      );
    
  writeback_stage writeback(.clk_i(clk_i)
                            ,.rst_i(rst_i)
                            
                            ,.stall_v_i(writeback_stall_v)
                            
                            ,.cword_i(memory_cword)
                            ,.cword_o(writeback_cword)
                            
                            ,.dword_i(memory_dword)
                            ,.dword_o(writeback_dword)
                            
                            ,.alu_or_ld_result_i(memory_alu_or_ld_result)
                            
                            ,.rd_o(writeback_rd)
                            ,.rd_data_o(writeback_rd_data)
                            ,.rd_w_v_o(writeback_rd_w_v)
                            );
                            
  hazard hazard(.imem_read_v_i('1)
                ,.imem_resp_v_i(imem_resp_v_i)
                ,.dmem_read_v_i(dmem_r_v_o)
                ,.dmem_resp_v_i(dmem_resp_v_i)
                
                ,.decode_br_v_i(decode_br_v)
                ,.rfetch_br_v_i(rfetch_cword.br_v)
                ,.execute_br_v_i(execute_cword.br_v)
                ,.memory_br_v_i(memory_cword.br_v)
                
                ,.ifetch_stall_v_o(ifetch_stall_v)
                ,.decode_stall_v_o(decode_stall_v)
                ,.rfetch_stall_v_o(rfetch_stall_v)
                ,.execute_stall_v_o(execute_stall_v)
                ,.memory_stall_v_o(memory_stall_v)
                ,.writeback_stall_v_o(writeback_stall_v)
                
                ,.bubble_v_o(bubble_v)
                ); 
                
  forwarding #()
    forward(.memory_rd_w_v_i(memory_cword.rd_w_v)
            ,.memory_rd_i(memory_cword.rd)
                
            ,.writeback_rd_w_v_i(writeback_cword.rd_w_v)
            ,.writeback_rd_i(writeback_cword.rd)
                
            ,.execute_rs1_i(execute_cword.rs1)
            ,.execute_rs2_i(execute_cword.rs2)
            
            ,.execute_rs1_v_i(~execute_cword.addpc_v)
            ,.execute_rs2_v_i(~execute_cword.imm_v)
                    
            ,.forward_memory_execute_rs1_v_o(forward_memory_execute_rs1_v)
            ,.forward_memory_execute_rs2_v_o(forward_memory_execute_rs2_v)
                    
            ,.forward_writeback_execute_rs1_v_o(forward_writeback_execute_rs1_v)
            ,.forward_writeback_execute_rs2_v_o(forward_writeback_execute_rs2_v)
            );

endmodule : rvga_top
