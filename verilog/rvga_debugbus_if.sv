`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

interface rvga_debugbus_if;
  rvga_opcode_e opcode;
  rvga_inst_type_e inst_type;  
  rvga_brop_e brop;
  rvga_ldop_e ldop;
  rvga_strop_e strop;
  rvga_artop_e artop;
  
  modport i(input opcode
            , input inst_type
            , input brop
            , input ldop
            , input strop
            , input artop
            );
            
  modport o(input opcode
            , output inst_type
            , output brop
            , output ldop
            , output strop
            , output artop
            );
endinterface