`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

module alu
  ( input rvga_artop_e op
    , input rvga_word a
    , input rvga_word b
    , input logic alt
    
    , output rvga_word o
   );
  
always_comb begin
  case(op)
    e_rvga_artop_addsub: o = alt ? a - b : a + b;
    e_rvga_artop_sll: o = a << b;
    e_rvga_artop_slt: o = (a < b);
    e_rvga_artop_sltu: o = ($unsigned(a) < $unsigned(b));
    e_rvga_artop_xor: o = a ^ b;
    e_rvga_artop_srx: o = alt ? ($signed(a) >>> $signed(b)) : (a >> b);
    e_rvga_artop_or: o = a | b;
    e_rvga_artop_and: o = a & b;
    default: o = 0;
  endcase
end

endmodule : alu
