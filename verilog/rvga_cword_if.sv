`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

interface rvga_cword_if;
  logic rd_w_v;
  logic pc_w_v;
  logic imm_v;
  logic rs1_pc_sel;
  logic imm_passthrough_v;
  rvga_artop_e artop;
  rvga_brop_e brop;
  rvga_ldop_e ldop;
  rvga_strop_e strop;
  logic alt_art;
    
  modport i(input rd_w_v
            , input pc_w_v
            , input imm_v
            , input rs1_pc_sel
            , input imm_passthrough_v
            , input artop
            , input brop
            , input ldop
            , input strop
            , input alt_art
            );
              
  modport o(output rd_w_v
            , output pc_w_v
            , output imm_v
            , output rs1_pc_sel
            , output imm_passthrough_v
            , output artop
            , output brop
            , output ldop
            , output strop
            , output alt_art
            );

endinterface : rvga_cword_if
