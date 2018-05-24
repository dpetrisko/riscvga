`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

interface rvga_debug_io;
  rvga_opcode_e opcode;
  rvga_inst_type_e inst_type;  
  rvga_brop_e brop;
  rvga_lop_e lop;
  rvga_strop_e strop;
  rvga_artop_e artop;
endinterface