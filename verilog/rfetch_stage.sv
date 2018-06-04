`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

module rfetch_stage
  ( input logic clk_i
    , input logic rst_i  
    
    , input rvga_word decode_pc
    , input rvga_reg decode_rs1
    , input rvga_reg decode_rs2
    , input rvga_reg decode_rd
    , input rvga_word decode_imm_data
    , input rvga_cword_s cword_i
   
    , output rvga_word rfetch_pc
    , output rvga_reg rfetch_rs1
    , output rvga_reg rfetch_rs2
    , output rvga_reg rfetch_rd
    , output rvga_word rfetch_imm_data
    , output rvga_word rfetch_rs1_data
    , output rvga_word rfetch_rs2_data
    
    , output rvga_cword_s cword_o
    
    , input logic writeback_rd_w_v
    , input rvga_reg writeback_rd
    , input rvga_word writeback_rd_data
    
    , input rvga_dword_s dword_i
    , output rvga_dword_s dword_o
    );
    
rvga_word rs1_data;
rvga_word rs2_data;
    
regfile #(.width_p($bits(rvga_word))
          ,.reg_els_p(32)
          )
 pregfile(.clk_i(clk_i)
          ,.rst_i(rst_i)
          
          ,.rd_w_v_i(writeback_rd_w_v)
          ,.rs1_i(decode_rs1)
          ,.rs2_i(decode_rs2)
          ,.rd_i(writeback_rd)
          ,.data_rs1_o(rfetch_rs1_data)
          ,.data_rs2_o(rfetch_rs2_data)
          ,.data_rd_i(writeback_rd_data)
          );

always_ff @(posedge clk_i) begin
  if (rst_i) begin
    rfetch_pc <= '0;
    rfetch_rs1 <= '0;
    rfetch_rs2 <= '0;
    rfetch_rd <= '0;
    rfetch_imm_data <= '0;
    
    cword_o <= '0;
    dword_o <= '0;
  end else begin
    rfetch_pc <= decode_pc;
    rfetch_rs1 <= decode_rs1;
    rfetch_rs2 <= decode_rs2;
    rfetch_rd <= decode_rd;
    rfetch_imm_data <= decode_imm_data;
    
    cword_o <= cword_i;
    dword_o <= dword_i;
  end
end

always_comb begin

end

endmodule : rfetch_stage
