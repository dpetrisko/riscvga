`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

module execute_stage
  ( input logic clk
    , input logic rst
    
    , input rvga_word rfetch_execute_pc
    , input rvga_reg rfetch_execute_rs1
    , input rvga_reg rfetch_execute_rs2
    , input rvga_reg rfetch_execute_rd
    , input rvga_word rfetch_execute_imm_data
    , input rvga_word rfetch_execute_rs1_data
    , input rvga_word rfetch_execute_rs2_data
    , rvga_cword_if.i cword_i
    
    , input logic forwarding_rs1_v
    , input logic forwarding_rs2_v
    , input rvga_word execute_result

    , output rvga_reg execute_memory_rs1
    , output rvga_reg execute_memory_rs2
    , output rvga_reg execute_memory_rd
    , output rvga_word execute_memory_result
    , rvga_cword_if.o cword_o
    
    `ifdef INST_DEBUG_BUS
    , rvga_debugbus_if.i debugbus_i
    , rvga_debugbus_if.o debugbus_o
    `endif
    );

rvga_word alu_result;
rvga_word alu_srca;
rvga_word alu_srcb;

always_ff @(posedge clk) begin
  `ifdef INST_DEBUG_BUS
    debugbus_o.opcode <= debugbus_i.opcode;
    debugbus_o.inst_type <= debugbus_i.inst_type;  
    debugbus_o.brop <= debugbus_i.brop;
    debugbus_o.ldop <= debugbus_i.ldop;
    debugbus_o.strop <= debugbus_i.strop;
    debugbus_o.artop <= debugbus_i.artop;
  `endif
  
  execute_memory_rs1 <= rfetch_execute_rs1;
  execute_memory_rs2 <= rfetch_execute_rs2;
  execute_memory_rd <= rfetch_execute_rd;
  execute_memory_result <= alu_result;
  
  cword_o.rd_w_v <= cword_i.rd_w_v;
  cword_o.pc_w_v <= cword_i.pc_w_v;
  cword_o.artop <= cword_i.artop;
  cword_o.brop <= cword_i.brop;
  cword_o.ldop <= cword_i.ldop;
  cword_o.strop <= cword_i.strop;
  cword_o.imm_v <= cword_i.imm_v; 
  cword_o.rs1_pc_sel <= cword_i.rs1_pc_sel;
  cword_o.imm_passthrough_v <= cword_i.imm_passthrough_v;
  cword_o.alt_art <= cword_i.alt_art;
end

always_comb begin
  alu_srca = cword_i.rs1_pc_sel ? rfetch_execute_pc : (cword_i.imm_passthrough_v ? 32'b0 : (forwarding_rs1_v ? execute_result : (rfetch_execute_rs1_data)));
  alu_srcb = cword_i.imm_v ? rfetch_execute_imm_data : (forwarding_rs2_v ? execute_result : rfetch_execute_rs2_data);
end

alu #(
      )
 alu (.op(cword_i.artop)
      ,.a(alu_srca)
      ,.b(alu_srcb)
      ,.alt(cword_i.alt_art)
      
      ,.o(alu_result)
      );

endmodule : execute_stage
