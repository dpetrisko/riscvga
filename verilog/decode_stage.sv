import rvga_types::*;

module decode_stage
  ( input logic clk
    , input logic rst
    
    , input rvga_word ifetch_decode_instruction
    
    , output logic decode_hazard_pc_redirect
    );

rvga_opcode opcode;
rvga_inst_type inst_type;
rvga_word imm;

always_ff @(posedge clk) begin

end

always_comb begin
  opcode = rvga_opcode'(ifetch_decode_instruction[6:0]);
    
  case(opcode) 
    rvga_opcode_branch: begin 
        inst_type = rvga_inst_type_b;
    end
    
    rvga_opcode_imm : begin 
        inst_type = rvga_inst_type_i;
    end
  endcase
  
  case(inst_type)
    rvga_inst_type_r: imm = 0;
    rvga_inst_type_i: imm = {{20{ifetch_decode_instruction[31]}}, ifetch_decode_instruction[31:20]};
    rvga_inst_type_s: imm = {{20{ifetch_decode_instruction[31]}}, ifetch_decode_instruction[31:25], ifetch_decode_instruction[11:7]};
    rvga_inst_type_b: imm = {{20{ifetch_decode_instruction[31]}}, ifetch_decode_instruction[7], ifetch_decode_instruction[30:25], ifetch_decode_instruction[11:8]};
    rvga_inst_type_u: imm = {{12{ifetch_decode_instruction[31]}}, ifetch_decode_instruction[31:12]};
    rvga_inst_type_j: imm = {{12{ifetch_decode_instruction[31]}}, ifetch_decode_instruction[19:12], ifetch_decode_instruction[20], ifetch_decode_instruction[30:21]};
  endcase
end 

endmodule : decode_stage
