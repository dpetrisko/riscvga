`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

module rvga_top #(parameter enable_caches = 0)
(
    input logic clk
    , input logic rst
    
    , rvga_membus_io.master imembus_if_io
    , rvga_membus_io.master dmembus_if_io
);

rvga_word ifetch_decode_instruction;

rvga_word writeback_ifetch_pc_target;
logic writeback_ifetch_pc_redirect_v;

rvga_reg decode_rfetch_rs1;
rvga_reg decode_rfetch_rs2;
rvga_reg decode_rfetch_rd;
logic decode_rfetch_rd_w_v;
rvga_word decode_rfetch_imm_data;
logic decode_rfetch_imm_v;
rvga_artop_e decode_rfetch_artop;
logic decode_rfetch_alt_art;

rvga_word rfetch_execute_rs1_data;
rvga_word rfetch_execute_rs2_data;
    
logic writeback_rfetch_rd_w_v;
rvga_reg writeback_rfetch_rd;
rvga_word writeback_rfetch_rd_data;

rvga_reg rfetch_execute_rs1;
rvga_reg rfetch_execute_rs2;
rvga_reg rfetch_execute_rd;
logic rfetch_execute_rd_w_v;
rvga_word rfetch_execute_imm_data;
logic rfetch_execute_imm_v;
rvga_artop_e rfetch_execute_artop;
logic rfetch_execute_alt_art;

rvga_reg execute_memory_rs1;
rvga_reg execute_memory_rs2;
rvga_reg execute_memory_rd;
logic execute_memory_rd_w_v;
rvga_word execute_memory_result;

rvga_reg memory_writeback_rd;
rvga_word memory_writeback_result;
logic memory_writeback_rd_w_v;

rvga_debug_io decode_debug_if();
rvga_debug_io rfetch_debug_if();
rvga_debug_io execute_debug_if();
rvga_debug_io memory_debug_if();
rvga_debug_io writeback_debug_if();

rvga_membus_io ifetch_membus_if();
rvga_membus_io memory_membus_if();

generate
  ifetch_stage ifetch(.membus_if_io(ifetch_membus_if)
                      ,.*);
    
  decode_stage decode(.debug_if_o(decode_debug_if)
                      ,.*);
    
  rfetch_stage rfetch(.debug_if_i(decode_debug_if)
                      ,.debug_if_o(rfetch_debug_if)
                      ,.*);
    
  execute_stage execute(.debug_if_i(rfetch_debug_if)
                        ,.debug_if_o(execute_debug_if)
                        ,.*);
    
  memory_stage memory(.membus_if_io(memory_membus_if)
                      ,.debug_if_i(execute_debug_if)
                      ,.debug_if_o(memory_debug_if)
                      ,.*);
    
  writeback_stage writeback(.debug_if_i(memory_debug_if)
                            ,.debug_if_o(writeback_debug_if)
                            ,.*);
                            
  if(enable_caches) begin
    l1cache #(.total_size_bytes(8 * 1024)
              ,.num_sets(4)
              )
        l1ic (.clk(clk)
              ,.rst(rst)
          
              ,.core_l1cache_addr(ifetch_membus_if.addr)
              ,.core_l1cache_read(ifetch_membus_if.read)
              ,.core_l1cache_write(1'b0)
              ,.l1cache_core_rdata(ifetch_membus_if.rdata)
              ,.core_l1cache_wdata(32'b0)
              ,.l1cache_core_resp(ifetch_membus_if.resp)
   
              ,.l1cache_ddr_addr(imembus_if_io.addr)
              ,.l1cache_ddr_read(imembus_if_io.read)
              ,.l1cache_ddr_write(1'b0)
              ,.ddr_l1cache_rdata(imembus_if_io.rdata)
              ,.l1cache_ddr_wdata(128'b0)
              ,.ddr_l1cache_resp(imembus_if_io.resp)
              );
          
    l1cache #(.total_size_bytes(8 * 1024)
              ,.num_sets(4)
              )
        l1id (.clk(clk)
              ,.rst(rst)
         
              ,.core_l1cache_addr(memory_membus_if.addr)
              ,.core_l1cache_read(memory_membus_if.read)
              ,.core_l1cache_write(memory_membus_if.write)
              ,.l1cache_core_rdata(memory_membus_if.rdata)
              ,.core_l1cache_wdata(memory_membus_if.wdata)
              ,.l1cache_core_resp(memory_membus_if.resp)
   
              ,.l1cache_ddr_addr(dmembus_if_io.addr)
              ,.l1cache_ddr_read(dmembus_if_io.read)
              ,.l1cache_ddr_write(dmembus_if_io.write)
              ,.ddr_l1cache_rdata(dmembus_if_io.rdata)
              ,.l1cache_ddr_wdata(dmembus_if_io.wdata)
              ,.ddr_l1cache_resp(dmembus_if_io.resp)
            );
  end else begin
    assign imembus_if_io.addr_o = ifetch_membus_if.addr;
    assign imembus_if_io.read_o = ifetch_membus_if.read;
    assign imembus_if_io.write_o = ifetch_membus_if.write;
    assign imembus_if_io.wdata_o = ifetch_membus_if.wdata;
    assign ifetch_membus_if.rdata = imembus_if_io.rdata_i;
    assign ifetch_membus_if.resp = imembus_if_io.resp_i;
    
    assign dmembus_if_io.addr_o = memory_membus_if.addr;
    assign dmembus_if_io.read_o = memory_membus_if.read;
    assign dmembus_if_io.write_o = memory_membus_if.write;
    assign dmembus_if_io.wdata_o = memory_membus_if.wdata;
    assign memory_membus_if.rdata = dmembus_if_io.rdata_i;
    assign memory_membus_if.resp = dmembus_if_io.resp_i;
  end
endgenerate

endmodule : rvga_top
