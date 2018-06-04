`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

module execute_stage
  ( input logic clk_i
    , input logic rst_i
    
    , input rvga_word rfetch_pc
    , input rvga_reg rfetch_rs1
    , input rvga_reg rfetch_rs2
    , input rvga_reg rfetch_rd
    , input rvga_word rfetch_imm_data
    , input rvga_word rfetch_rs1_data
    , input rvga_word rfetch_rs2_data
    , rvga_cword_s cword_i
    
    , input logic forwarding_execute_rs1_v
    , input logic forwarding_execute_rs2_v
    
    , input logic forwarding_memory_rs1_v
    , input logic forwarding_memory_rs2_v
    , input rvga_word memory_result

    , output rvga_reg execute_rs1
    , output rvga_reg execute_rs2
    , output rvga_reg execute_rd
    , output rvga_word execute_result
    , output rvga_word execute_data
    , rvga_cword_s cword_o
    
    , input rvga_dword_s dword_i
    , output rvga_dword_s dword_o
    );

rvga_word alu_result;
rvga_word alu_srca;
rvga_word alu_srcb;

always_ff @(posedge clk_i) begin
  if (rst_i) begin
    execute_rs1 <= '0;
    execute_rs2 <= '0;
    execute_rd <= '0;
    execute_result <= '0;
    execute_data <= '0;
    
    cword_o <= '0;
    dword_o <= '0;
  end else begin
    execute_rs1 <= rfetch_rs1;
    execute_rs2 <= rfetch_rs2;
    execute_rd <= rfetch_rd;
    execute_result <= cword_i.imm_passthrough_v ? rfetch_imm_data : alu_result;
    execute_data <= rfetch_rs2_data;
    
    cword_o <= cword_i;
    dword_o <= dword_i;
  end
end

always_comb begin
  alu_srca = cword_i.rs1_pc_sel ? rfetch_pc : (forwarding_memory_rs1_v ? memory_result : (forwarding_execute_rs1_v ? execute_result : (rfetch_rs1_data)));
  alu_srcb = cword_i.imm_v ? rfetch_imm_data : (forwarding_memory_rs2_v ? memory_result : (forwarding_execute_rs2_v ? execute_result : rfetch_rs2_data));
end

alu #(
      )
 alu (.op(rvga_artop_e'(cword_i.funct3))
      ,.a(alu_srca)
      ,.b(alu_srcb)
      ,.alt(cword_i.alt_art)
      
      ,.o(alu_result)
      );

endmodule : execute_stage
