`include "rvga_types.sv"
import rvga_types::*;

module rfetch_stage
  ( input logic clk
    , input logic rst

`ifdef INST_DEBUG_BUS    
    , input rvga_opcode_e decode_rfetch_opcode
    , input rvga_inst_type_e decode_rfetch_inst_type
    , input rvga_funct3 decode_refetch_funct3
    , input rvga_funct7 decode_refetch_funct7
`endif    
    
    , input rvga_reg decode_rfetch_rs1
    , input rvga_reg decode_rfetch_rs2
    , input rvga_reg decode_rfetch_rd
    , input rvga_word decode_rfetch_imm_data
    , input logic decode_rfetch_imm_v
    , input rvga_artop decode_rfetch_artop
    , input logic decode_rfetch_alt_art
    
`ifdef INST_DEBUG_BUS
    , output rvga_opcode_e rfetch_execute_opcode
    , output rvga_inst_type_e rfetch_execute_inst_type
    , output rvga_funct3 refetch_execute_funct3
    , output rvga_funct7 refetch_execute_funct7
`endif   
   
    , output rvga_reg rfetch_execute_rs1
    , output rvga_reg rfetch_execute_rs2
    , output rvga_reg rfetch_execute_rd
    , output rvga_word rfetch_execute_imm_data
    , output logic rfetch_execute_imm_v
    , output rvga_word rfetch_execute_rs1_data
    , output rvga_word rfetch_execute_rs2_data
    , output rvga_artop rfetch_execute_artop
    , output logic rfetch_execute_alt_art
    
    , input logic writeback_rfetch_rd_w_v
    , input rvga_reg writeback_rfetch_rd
    , input rvga_word writeback_rfetch_rd_data
    );
    
regfile #(.width_p(32)
          ,.reg_els_p(32)
          )
 pregfile(.clk(clk)
          ,.rst(rst)
          
          ,.rd_w_v_i(writeback_rfetch_rd_w_v)
          ,.rs1_i(decode_rfetch_rs1)
          ,.rs2_i(decode_rfetch_rs2)
          ,.rd_i(writeback_rfetch_rd)
          ,.data_rs1_o(rfetch_execute_rs1_data)
          ,.data_rs2_o(rfetch_execute_rs2_data)
          ,.data_rd_i(writeback_rfetch_rd_data)
          );

always_ff @(posedge clk) begin
`ifdef INST_DEBUG_BUS
    rfetch_execute_opcode <= decode_rfetch_opcode;
    rfetch_execute_inst_type <= decode_rfetch_inst_type;
    refetch_execute_funct3 <= decode_refetch_funct3;
    refetch_execute_funct7 <= decode_refetch_funct7;
`endif
    rfetch_execute_rs1 <= decode_rfetch_rs1;
    rfetch_execute_rs2 <= decode_rfetch_rs2;
    rfetch_execute_rd <= decode_rfetch_rd;
    rfetch_execute_imm_data <= decode_rfetch_imm_data;
    rfetch_execute_imm_v <= decode_rfetch_imm_v;
    rfetch_execute_artop <= decode_rfetch_artop;
    rfetch_execute_alt_art <= decode_rfetch_alt_art;
end

always_comb begin

end

endmodule : rfetch_stage
