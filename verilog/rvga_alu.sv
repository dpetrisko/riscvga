`include "rvga_types.sv"
import rvga_types::*;

module rvga_alu 
  ( input rvga_word a_i
    , input rvga_word b_i
    , input rvga_funct3 op_i
    , input logic alt_i
    , input logic addr_calc_v_i
    
    , output rvga_word o
    );
    
always_comb begin
  if (addr_calc_v_i) begin
    o = (a_i + b_i);
  end else begin
    case (op_i) 
      e_rvga_artop_addsub: o = alt_i ? (a_i - b_i) : (a_i + b_i);
      e_rvga_artop_sll: o = a_i << b_i;  
      e_rvga_artop_slt: o = ($signed(a_i) < $signed(b_i));
      e_rvga_artop_sltu: o = ($unsigned(a_i) < $unsigned(b_i));
      e_rvga_artop_xor: o = a_i ^ b_i;
      e_rvga_artop_srx: o = alt_i ? $signed($signed(a_i) >>> $signed(b_i)) : (a_i >> b_i);
      e_rvga_artop_or: o = a_i | b_i;   
      e_rvga_artop_and: o = a_i & b_i;
    endcase
  end
end

endmodule : rvga_alu
