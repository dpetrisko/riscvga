`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

module rvga_top #(parameter enable_caches = 0)
(
    input logic clk
    , input logic rst
    
    , rvga_membus_if.master imembus_io
    , rvga_membus_if.master dmembus_io
);

rvga_word ifetch_decode_pc;
rvga_word ifetch_decode_instruction;

rvga_word writeback_ifetch_pc_target;
logic writeback_ifetch_pc_w_v;

rvga_word decode_rfetch_pc;
rvga_reg decode_rfetch_rs1;
rvga_reg decode_rfetch_rs2;
rvga_reg decode_rfetch_rd;
logic decode_rfetch_rd_w_v;
logic decode_rfetch_pc_w_v;
rvga_word decode_rfetch_imm_data;
logic decode_rfetch_imm_v;
logic decode_rfetch_imm_passthrough_v;
logic decode_rfetch_rs1_pc_sel;
rvga_artop_e decode_rfetch_artop;
logic decode_rfetch_alt_art;

rvga_word rfetch_execute_rs1_data;
rvga_word rfetch_execute_rs2_data;
    
logic writeback_rfetch_rd_w_v;
rvga_reg writeback_rfetch_rd;
rvga_word writeback_rfetch_rd_data;

rvga_word rfetch_execute_pc;
rvga_reg rfetch_execute_rs1;
rvga_reg rfetch_execute_rs2;
rvga_reg rfetch_execute_rd;
logic rfetch_execute_rd_w_v;
logic rfetch_execute_pc_w_v;
rvga_word rfetch_execute_imm_data;
logic rfetch_execute_imm_v;
logic rfetch_execute_imm_passthrough_v;
logic rfetch_execute_rs1_pc_sel;
rvga_artop_e rfetch_execute_artop;
logic rfetch_execute_alt_art;

rvga_reg execute_memory_rs1;
rvga_reg execute_memory_rs2;
rvga_reg execute_memory_rd;
logic execute_memory_rd_w_v;
logic execute_memory_pc_w_v;
rvga_word execute_memory_result;

rvga_reg memory_writeback_rd;
rvga_word memory_writeback_result;
logic memory_writeback_rd_w_v;
logic memory_writeback_pc_w_v;

logic forwarding_rs1_v;
logic forwarding_rs2_v;

rvga_debugbus_if decode_debugbus();
rvga_debugbus_if rfetch_debugbus();
rvga_debugbus_if execute_debugbus();
rvga_debugbus_if memory_debugbus();
rvga_debugbus_if writeback_debugbus();

rvga_cachebus_if ifetch_cachebus();
rvga_cachebus_if memory_cachebus();

generate
  ifetch_stage ifetch(.cachebus_io(ifetch_cachebus)
                      ,.*
                      );
    
  decode_stage decode(.debugbus_o(decode_debugbus)
                      ,.*
                      );
    
  rfetch_stage rfetch(.debugbus_i(decode_debugbus)
                      ,.debugbus_o(rfetch_debugbus)
                      ,.*
                      );
    
  execute_stage execute(.debugbus_i(rfetch_debugbus)
                        ,.debugbus_o(execute_debugbus)
                        ,.forwarding_rs1_v(forwarding_rs1_v)
                        ,.forwarding_rs2_v(forwarding_rs2_v)
                        ,.execute_result(execute_memory_result)
                        ,.*
                        );
    
  memory_stage memory(.cachebus_io(memory_cachebus)
                      ,.debugbus_i(execute_debugbus)
                      ,.debugbus_o(memory_debugbus)
                      ,.*
                      );
    
  writeback_stage writeback(.debugbus_i(memory_debugbus)
                            ,.debugbus_o(writeback_debugbus)
                            ,.*
                            );
                            
  forwarding forwarding(.execute_rd_w_v(execute_memory_rd_w_v)
                        ,.execute_rd(execute_memory_rd)
                    
                        ,.rfetch_rs1(rfetch_execute_rs1)
                        ,.rfetch_rs2(rfetch_execute_rs2)
                        
                        ,.forwarding_rs1_v(forwarding_rs1_v)
                        ,.forwarding_rs2_v(forwarding_rs2_v)
                        );
                            
  if(enable_caches) begin
    l1cache #(.total_size_bytes(8 * 1024)
              ,.num_sets(4)
              )
        l1ic (.clk(clk)
              ,.rst(rst)
          
              ,.cachebus_io(ifetch_cachebus)
              ,.membus_io(imembus_io)
              );
          
    l1cache #(.total_size_bytes(8 * 1024)
              ,.num_sets(4)
              )
        l1id (.clk(clk)
              ,.rst(rst)
         
              ,.cachebus_io(memory_cachebus)
              ,.membus_io(dmembus_io)
            );
  end else begin
    assign imembus_io.addr_o = ifetch_cachebus.addr;
    assign imembus_io.read_o = ifetch_cachebus.read;
    assign imembus_io.write_o = ifetch_cachebus.write;
    assign imembus_io.wdata_o = ifetch_cachebus.wdata;
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
