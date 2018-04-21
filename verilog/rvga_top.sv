`include "rvga_types.svh"

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

rvga_word dddr_dcache_wdata;
rvga_word memory_dcache_addr;
logic memory_dcache_read;
rvga_word dcache_memory_rdata;
logic memory_dcache_write;
rvga_word memory_dcache_wdata;
logic dcache_memory_resp;

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
          ,.core_l1cache_write(0)
          ,.l1cache_core_rdata(icache_ifetch_rdata)
          ,.core_l1cache_wdata(0)
          ,.l1cache_core_resp(icache_ifetch_resp)
   
          ,.l1cache_ddr_addr(icache_iddr_addr)
          ,.l1cache_ddr_read(icache_iddr_read)
          ,.l1cache_ddr_write(0)
          ,.ddr_l1cache_rdata(iddr_icache_rdata)
          ,.l1cache_ddr_wdata(0)
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
          ,.core_l1cache_wdata(dddr_dcache_wdata)
          ,.l1cache_core_resp(dcache_memory_resp)
   
          ,.l1cache_ddr_addr(dcache_dddr_addr)
          ,.l1cache_ddr_read(dcache_dddr_read)
          ,.l1cache_ddr_write(dcache_dddr_write)
          ,.ddr_l1cache_rdata(dddr_dcache_rdata)
          ,.l1cache_ddr_wdata(dcache_dddr_wdata)
          ,.ddr_l1cache_resp(dddr_dcache_resp)
          );


endmodule : rvga_top
