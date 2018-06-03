`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

module rvga_top #(parameter enable_caches = 0)
(
    input logic clk_i
    , input logic rst_i
    
    , rvga_membus_if.master imembus_io
    , rvga_membus_if.master dmembus_io
    
    , output rvga_cword_s cword_o 
    
    , output rvga_dword_s dword_o
);

rvga_word ifetch_pc;
rvga_word ifetch_inst;

rvga_word writeback_pc_target;

rvga_word decode_pc;
rvga_reg decode_rs1;
rvga_reg decode_rs2;
rvga_reg decode_rd;
rvga_word decode_imm_data;

rvga_word rfetch_rs1_data;
rvga_word rfetch_rs2_data;
    
logic writeback_rd_w_v;
rvga_reg writeback_rd;
rvga_word writeback_rd_data;

rvga_word rfetch_pc;
rvga_reg rfetch_rs1;
rvga_reg rfetch_rs2;
rvga_reg rfetch_rd;
rvga_word rfetch_imm_data;

rvga_reg execute_rs1;
rvga_reg execute_rs2;
rvga_reg execute_rd;
rvga_word execute_result;
rvga_word execute_data;

rvga_reg memory_rd;
rvga_word memory_result;

logic forwarding_execute_rs1_v;
logic forwarding_execute_rs2_v;

logic forwarding_memory_rs1_v;
logic forwarding_memory_rs2_v;

rvga_dword_s decode_dword;
rvga_dword_s rfetch_dword;
rvga_dword_s execute_dword;
rvga_dword_s memory_dword;

rvga_cachebus_if ifetch_cachebus();
rvga_cachebus_if memory_cachebus();

rvga_cword_s decode_cword;
rvga_cword_s rfetch_cword;
rvga_cword_s execute_cword;
rvga_cword_s memory_cword;

generate
  ifetch_stage ifetch(.cachebus_io(ifetch_cachebus)
                      ,.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      ,.*
                      );
    
  decode_stage decode(.dword_o(decode_dword)
                      ,.cword_o(decode_cword)
                      ,.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      ,.*
                      );
    
  rfetch_stage rfetch(.dword_i(decode_dword)
                      ,.dword_o(rfetch_dword)
                      ,.cword_i(decode_cword)
                      ,.cword_o(rfetch_cword)
                      ,.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      ,.*
                      );
    
  execute_stage execute(.dword_i(rfetch_dword)
                        ,.dword_o(execute_dword)
                        ,.cword_i(rfetch_cword)
                        ,.cword_o(execute_cword)
                        ,.clk_i(clk_i)
                        ,.rst_i(rst_i)
                        ,.forwarding_execute_rs1_v(forwarding_execute_rs1_v)
                        ,.forwarding_execute_rs2_v(forwarding_execute_rs2_v)
                        ,.execute_result(execute_result)
                        ,.forwarding_memory_rs1_v(forwarding_memory_rs1_v)
                        ,.forwarding_memory_rs2_v(forwarding_memory_rs2_v)
                        ,.memory_result(memory_result)
                        ,.*
                        );
    
  memory_stage memory(.cachebus_io(memory_cachebus)
                      ,.dword_i(execute_dword)
                      ,.dword_o(memory_dword)
                      ,.cword_i(execute_cword)
                      ,.cword_o(memory_cword)
                      ,.clk_i(clk_i)
                      ,.rst_i(rst_i)
                      ,.*
                      );
    
  writeback_stage writeback(.dword_i(memory_dword)
                            ,.dword_o(dword_o)
                            ,.cword_i(memory_cword)
                            ,.cword_o(cword_o)
                            ,.clk_i(clk_i)
                            ,.rst_i(rst_i)
                            ,.*
                            );
                            
  forwarding forwarding(.execute_rd_w_v(execute_cword.rd_w_v)
                        ,.execute_rd(execute_rd)
                        
                        ,.memory_rd_w_v(memory_cword.rd_w_v)
                        ,.memory_rd(memory_rd)
                    
                        ,.rfetch_rs1(rfetch_rs1)
                        ,.rfetch_rs2(rfetch_rs2)
                        
                        ,.forwarding_execute_rs1_v(forwarding_execute_rs1_v)
                        ,.forwarding_execute_rs2_v(forwarding_execute_rs2_v)
                        
                        ,.forwarding_memory_rs1_v(forwarding_memory_rs1_v)
                        ,.forwarding_memory_rs2_v(forwarding_memory_rs2_v)
                        );
                            
  if(enable_caches) begin
    l1cache #(.total_size_bytes(8 * 1024)
              ,.num_sets(4)
              )
        l1ic (.clk(clk_i)
              ,.rst(rst_i)
          
              ,.cachebus_io(ifetch_cachebus)
              ,.membus_io(imembus_io)
              );
          
    l1cache #(.total_size_bytes(8 * 1024)
              ,.num_sets(4)
              )
        l1id (.clk(clk_i)
              ,.rst(rst_i)
         
              ,.cachebus_io(memory_cachebus)
              ,.membus_io(dmembus_io)
            );
  end else begin
    assign imembus_io.addr_o = ifetch_cachebus.addr;
    assign imembus_io.read_o = ifetch_cachebus.read;
    assign ifetch_cachebus.rdata = imembus_io.rdata_i;
    assign ifetch_cachebus.resp = imembus_io.resp_i;
    
    assign dmembus_io.addr_o = memory_cachebus.addr;
    assign dmembus_io.read_o = memory_cachebus.read;
    assign dmembus_io.write_o = memory_cachebus.write;
    assign dmembus_io.wdata_o = memory_cachebus.wdata;
    assign memory_cachebus.rdata = dmembus_io.rdata_i;
    assign memory_cachebus.resp = dmembus_io.resp_i;
  end
endgenerate

endmodule : rvga_top
