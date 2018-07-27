`include "rvga_types.sv"
import rvga_types::*;

module imm_construct
  ( input rvga_inst_type inst_type_i
    , input logic[31:7] imm_raw_i
    , input logic shift_v_i

    , output rvga_word imm_o
    );

logic[6:0] inst_unused;

always_comb begin
  case(inst_type_i)
    e_rvga_inst_type_i: if(shift_v_i) begin
                            imm_o = {27'b0, imm_raw_i[24:20]};
                        end else begin
                            imm_o = {{20{imm_raw_i[31]}}, imm_raw_i[31:20]};
                        end
    e_rvga_inst_type_s: imm_o = {{20{imm_raw_i[31]}}, imm_raw_i[31:25], imm_raw_i[11:7]};
    e_rvga_inst_type_b: imm_o = {{20{imm_raw_i[31]}}, imm_raw_i[7], imm_raw_i[30:25], imm_raw_i[11:8], 1'b0};
    e_rvga_inst_type_u: imm_o = {imm_raw_i[31:12], {12{1'b0}}};
    e_rvga_inst_type_j: imm_o = {{12{imm_raw_i[31]}}, imm_raw_i[19:12], imm_raw_i[20], imm_raw_i[30:21], 1'b0};
    default: imm_o = 0;
  endcase
end

endmodule : imm_construct
