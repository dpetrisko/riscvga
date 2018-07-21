`include "rvga_types.sv"
import rvga_types::*;

module rvga_bru 
  ( input rvga_word a_i
    , input rvga_word b_i
    , input rvga_funct3 op_i
    
    , output logic o
    );
    
always_comb begin
  case (op_i) 
    e_rvga_brop_beq : o = (a_i == b_i);
    e_rvga_brop_bne : o = (a_i != b_i);
    e_rvga_brop_blt : o = ($signed(a_i) <  $signed(b_i));
    e_rvga_brop_bge : o = ($signed(a_i) >= $signed(b_i));
    e_rvga_brop_bltu: o = ($unsigned(a_i) < $unsigned(b_i));
    e_rvga_brop_bgeu: o = ($unsigned(a_i) >= $unsigned(b_i));
    default         : o = '0;
  endcase
end

endmodule : rvga_bru
