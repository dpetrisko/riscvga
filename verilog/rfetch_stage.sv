`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

module rfetch_stage
  ( input logic clk
    , input logic rst  
    
    , input rvga_word decode_rfetch_pc
    , input rvga_reg decode_rfetch_rs1
    , input rvga_reg decode_rfetch_rs2
    , input rvga_reg decode_rfetch_rd
    , input rvga_word decode_rfetch_imm_data
    , rvga_cword_if.i cword_i
   
    , output rvga_word rfetch_execute_pc
    , output rvga_reg rfetch_execute_rs1
    , output rvga_reg rfetch_execute_rs2
    , output rvga_reg rfetch_execute_rd
    , output rvga_word rfetch_execute_imm_data
    , output rvga_word rfetch_execute_rs1_data
    , output rvga_word rfetch_execute_rs2_data
    , rvga_cword_if.o cword_o
    
    , input logic writeback_rfetch_rd_w_v
    , input rvga_reg writeback_rfetch_rd
    , input rvga_word writeback_rfetch_rd_data
    
    `ifdef INST_DEBUG_BUS    
    , rvga_debugbus_if.i debugbus_i
    , rvga_debugbus_if.o debugbus_o
    `endif  
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
    debugbus_o.opcode <= debugbus_i.opcode;
    debugbus_o.inst_type <= debugbus_i.inst_type;  
    debugbus_o.brop <= debugbus_i.brop;
    debugbus_o.ldop <= debugbus_i.ldop;
    debugbus_o.strop <= debugbus_i.strop;
    debugbus_o.artop <= debugbus_i.artop;
  `endif

  rfetch_execute_pc <= decode_rfetch_pc;
  rfetch_execute_rs1 <= decode_rfetch_rs1;
  rfetch_execute_rs2 <= decode_rfetch_rs2;
  rfetch_execute_rd <= decode_rfetch_rd;
  rfetch_execute_imm_data <= decode_rfetch_imm_data;
  
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

end

endmodule : rfetch_stage
