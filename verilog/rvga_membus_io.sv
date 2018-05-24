`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

interface rvga_membus_io;
  rvga_word addr;
  logic read;
  rvga_word rdata;
  logic write;
  rvga_word wdata;
  logic resp;
  
  modport master
    ( output .addr_o(addr)
      , output .read_o(read)
      , input .rdata_i(rdata)
      , output .write_o(write)
      , output .wdata_o(wdata)
      , input .resp_i(resp)
      );
 
  modport slave
    ( input .addr_i(addr)
      , input .read_i(read)
      , output .rdata_o(rdata)
      , input .write_i(write)
      , input .wdata_i(wdata)
      , output .resp_o(resp)
      );
endinterface