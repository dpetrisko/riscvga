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

icache ic(.*);

dcache dc(.*);

endmodule : rvga_top
