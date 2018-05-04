`include "rvga_types.sv"
import rvga_types::*;

module rvga_top
(
    input logic clk,
    input logic rst,
    
    output rvga_word icache_iddr_addr,
    output logic icache_iddr_read,
    input rvga_cacheline iddr_icache_rdata,
    input logic iddr_icache_resp,
    
    output rvga_word dcache_dddr_addr,
    output logic dcache_dddr_read,
    input rvga_cacheline dddr_dcache_rdata,
    output logic dcache_dddr_write,
    output rvga_cacheline dcache_dddr_wdata,
    input logic dddr_dcache_resp
);

rvga_word ifetch_decode_instruction;

rvga_word ifetch_icache_addr;
logic ifetch_icache_read;
rvga_word icache_ifetch_rdata;
logic icache_ifetch_resp;

rvga_word memory_dcache_addr;
logic memory_dcache_read;
rvga_word dcache_memory_rdata;
logic memory_dcache_write;
rvga_word memory_dcache_wdata;
logic dcache_memory_resp;

rvga_word writeback_ifetch_pc_target;
logic writeback_ifetch_pc_redirect;

rvga_opcode_e decode_rfetch_opcode;
rvga_inst_type_e decode_rfetch_inst_type;
rvga_funct3 decode_refetch_funct3;
rvga_funct7 decode_refetch_funct7;
rvga_reg decode_rfetch_rs1;
rvga_reg decode_rfetch_rs2;
rvga_reg decode_rfetch_rd;
rvga_word decode_rfetch_imm;

rvga_word rfetch_execute_rs1_data;
rvga_word rfetch_execute_rs2_data;
    
logic writeback_rfetch_rd_w_v;
rvga_reg writeback_rfetch_rd;
rvga_word writeback_rfetch_rd_data;

rvga_opcode_e rfetch_execute_opcode;
rvga_inst_type_e rfetch_execute_inst_type;
rvga_funct3 refetch_execute_funct3;
rvga_funct7 refetch_execute_funct7;
rvga_reg rfetch_execute_rs1;
rvga_reg rfetch_execute_rs2;
rvga_reg rfetch_execute_rd;
rvga_word rfetch_execute_imm;

rvga_opcode_e execute_memory_opcode;
rvga_inst_type_e execute_memory_inst_type;
rvga_funct3 execute_memory_funct3;
rvga_funct7 execute_memory_funct7;

rvga_reg execute_memory_rs1;
rvga_reg execute_memory_rs2;
rvga_reg execute_memory_rd;
rvga_word execute_memory_rd_data;

ifetch_stage ifetch(.*);

decode_stage decode(.*);

rfetch_stage rfetch(.*);

execute_stage execute(.*);

memory_stage memory(.*);

writeback_stage writeback(.*);

l1cache #(.total_size_bytes(8 * 1024)
          ,.num_sets(4)
          )
    l1ic (.clk(clk)
          ,.rst(rst)
          
          ,.core_l1cache_addr(ifetch_icache_addr)
          ,.core_l1cache_read(ifetch_icache_read)
          ,.core_l1cache_write(1'b0)
          ,.l1cache_core_rdata(icache_ifetch_rdata)
          ,.core_l1cache_wdata(32'b0)
          ,.l1cache_core_resp(icache_ifetch_resp)
   
          ,.l1cache_ddr_addr(icache_iddr_addr)
          ,.l1cache_ddr_read(icache_iddr_read)
          ,.l1cache_ddr_write()
          ,.ddr_l1cache_rdata(iddr_icache_rdata)
          ,.l1cache_ddr_wdata()
          ,.ddr_l1cache_resp(iddr_icache_resp)
          );
          
l1cache #(.total_size_bytes(8 * 1024)
          ,.num_sets(4)
          )
    l1id (.clk(clk)
          ,.rst(rst)
        
          ,.core_l1cache_addr(memory_dcache_addr)
          ,.core_l1cache_read(memory_dcache_read)
          ,.core_l1cache_write(memory_dcache_write)
          ,.l1cache_core_rdata(dcache_memory_rdata)
          ,.core_l1cache_wdata(memory_dcache_wdata)
          ,.l1cache_core_resp(dcache_memory_resp)
   
          ,.l1cache_ddr_addr(dcache_dddr_addr)
          ,.l1cache_ddr_read(dcache_dddr_read)
          ,.l1cache_ddr_write(dcache_dddr_write)
          ,.ddr_l1cache_rdata(dddr_dcache_rdata)
          ,.l1cache_ddr_wdata(dcache_dddr_wdata)
          ,.ddr_l1cache_resp(dddr_dcache_resp)
          );


endmodule : rvga_top
