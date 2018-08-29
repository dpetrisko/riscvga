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
    , output rvga_wmask dmem_wmask_o
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

logic hazard_stall_v;
logic bubble_v;
logic forward_writeback_execute_rs1_v, forward_writeback_execute_rs2_v, forward_memory_execute_rs1_v, forward_memory_execute_rs2_v;
rvga_cword decode_cword, idrf_cword, rfex_cword, exmem_cword, memwb_cword, debug_cword;
logic decode_br_v, rfetch_br_v, execute_br_v, memory_br_v, writeback_br_v;
rvga_word writeback_rd_data;

logic writeback_btaken;
rvga_word writeback_btgt;

rvga_reg writeback_rd;
rvga_word memory_alu_or_ld_result, memwb_alu_or_ld_result; 
logic writeback_rd_w_v;

rvga_word execute_alu_result;
logic execute_bru_result;
logic bru_result;

  ifetch_stage ifetch(.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      ,.imem_addr_o(imem_addr_o)
                      ,.imem_data_i(imem_data_i)
                      
                      ,.stall_v_i(hazard_stall_v)
                      ,.bubble_v_i(bubble_v)
                      
                      ,.pc_o(pc)
                      ,.inst_v_o(inst_v)
                      ,.inst_o(inst)
                      
                      ,.btaken_i(writeback_btaken)
                      ,.btgt_i(writeback_btgt)
                      );
    
  decode_stage decode(.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      
                      ,.stall_v_i(hazard_stall_v)
                      ,.bubble_v_i(bubble_v)
                      
                      ,.pc_i(pc)
                      ,.inst_v_i(inst_v)
                      ,.inst_i(inst)
                      
                      ,.cword_o(decode_cword)
                      
                      ,.imm_raw_o(decode_imm_raw)
                      ,.br_v_o(decode_br_v)
                      );

  idrf_latch idrf(.clk_i(clk_i)
                  ,.rst_i(rst_i)
                    
                  ,.stall_v_i(hazard_stall_v)

                  ,.cword_i(decode_cword)
                  ,.cword_o(idrf_cword)
                  );
    
  rfetch_stage rfetch(.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      
                      ,.stall_v_i(hazard_stall_v)
                      
                      ,.cword_i(idrf_cword)
                      
                      ,.rd_i(writeback_rd)
                      ,.rd_data_i(writeback_rd_data) 
                      ,.rd_w_v_i(writeback_rd_w_v)
                      
                      ,.imm_raw_i(decode_imm_raw)
                      
                      ,.imm_data_o(rfetch_imm_data)
                      ,.rs1_data_o(rfetch_rs1_data)
                      ,.rs2_data_o(rfetch_rs2_data)
                     
                      ,.br_v_o(rfetch_br_v)
                      );

  rfex_latch rfex(.clk_i(clk_i)
                  ,.rst_i(rst_i)
                    
                  ,.stall_v_i(hazard_stall_v)

                  ,.cword_i(idrf_cword)
                  ,.cword_o(rfex_cword)
                  );
                      
  execute_stage execute(.clk_i(clk_i)
                        ,.rst_i(rst_i)
                        
                        ,.stall_v_i(hazard_stall_v)
                        
                        ,.cword_i(rfex_cword)
                        
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

  exmem_latch exmem(.clk_i(clk_i)
                    ,.rst_i(rst_i)
                    
                    ,.stall_v_i(hazard_stall_v)

                    ,.cword_i(rfex_cword)
                    ,.cword_o(exmem_cword)
                    );
    
  memory_stage memory(.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      
                      ,.stall_v_i(hazard_stall_v)
                      
                      ,.cword_i(exmem_cword)
                      
                      ,.alu_result_i(execute_alu_result)
                      ,.bru_result_i(execute_bru_result)
                      ,.st_data_i(execute_st_data)
                      
                      ,.dmem_r_v_o(dmem_r_v_o)
                      ,.dmem_w_v_o(dmem_w_v_o)
                      ,.dmem_addr_o(dmem_addr_o)
                      ,.dmem_data_i(dmem_data_i)
                      ,.dmem_data_o(dmem_data_o)
                      ,.dmem_wmask_o(dmem_wmask_o)
                      
                      ,.btaken_o(memory_btaken)
                      ,.alu_or_ld_result_o(memory_alu_or_ld_result)
                      
                      ,.br_v_o(memory_br_v)
                      );

  memwb_latch memwb(.clk_i(clk_i)
                    ,.rst_i(rst_i)
                    
                    ,.stall_v_i(hazard_stall_v)

                    ,.cword_i(exmem_cword)
                    ,.cword_o(memwb_cword)

                    ,.alu_or_ld_result_i(memory_alu_or_ld_result)
                    ,.alu_or_ld_result_o(memwb_alu_or_ld_result)

                    ,.btaken_i(memory_btaken)
                    ,.btaken_o(memwb_btaken)
                    );
    
  writeback_stage writeback(.clk_i(clk_i)
                            ,.rst_i(rst_i)
                            
                            ,.stall_v_i(hazard_stall_v)
                            
                            ,.cword_i(memwb_cword)
                            
                            ,.alu_or_ld_result_i(memwb_alu_or_ld_result)
                            
                            ,.rd_o(writeback_rd)
                            ,.rd_data_o(writeback_rd_data)
                            ,.rd_w_v_o(writeback_rd_w_v)

                            ,.btaken_i(memwb_btaken)

                            ,.br_v_o(writeback_br_v)
                            ,.btaken_o(writeback_btaken)
                            ,.btgt_o(writeback_btgt)
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
                
                ,.hazard_stall_v_o(hazard_stall_v)
                
                ,.bubble_v_o(bubble_v)
                ); 
                
  forwarding #()
    forward(.memory_rd_w_v_i(exmem_cword.rd_w_v)
            ,.memory_rd_i(exmem_cword.rd)
                
            ,.writeback_rd_w_v_i(memwb_cword.rd_w_v)
            ,.writeback_rd_i(memwb_cword.rd)
                
            ,.execute_rs1_i(rfex_cword.rs1)
            ,.execute_rs2_i(rfex_cword.rs2)
            
            ,.execute_rs1_v_i(~rfex_cword.addpc_v || rfex_cword.br_v)
            ,.execute_rs2_v_i(~rfex_cword.imm_v || rfex_cword.br_v || rfex_cword.dmem_w_v)
                    
            ,.forward_memory_execute_rs1_v_o(forward_memory_execute_rs1_v)
            ,.forward_memory_execute_rs2_v_o(forward_memory_execute_rs2_v)
                    
            ,.forward_writeback_execute_rs1_v_o(forward_writeback_execute_rs1_v)
            ,.forward_writeback_execute_rs2_v_o(forward_writeback_execute_rs2_v)
            );

endmodule : rvga_top
