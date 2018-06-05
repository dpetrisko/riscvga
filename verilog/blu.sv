`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

module blu
  ( input rvga_brop_e op
    , input rvga_word rs1_data
    , input rvga_word rs2_data
    , input logic prediction
    
    , output logic mispredict_v
   );
   
always_comb begin
  case (op)
    e_rvga_brop_beq:  mispredict_v = prediction ~^ (rs1_data == rs2_data);
    e_rvga_brop_bne:  mispredict_v = prediction ~^ (rs1_data != rs2_data);
    e_rvga_brop_blt:  mispredict_v = prediction ~^ (rs1_data <  rs2_data);
    e_rvga_brop_bge:  mispredict_v = prediction ~^ (rs1_data >= rs2_data);
    e_rvga_brop_bltu: mispredict_v = prediction ~^ ($unsigned(rs1_data) < $unsigned(rs2_data));
    e_rvga_brop_bgeu: mispredict_v = prediction ~^ ($unsigned(rs1_data) >= $unsigned(rs2_data));
  endcase
end

endmodule : blu

