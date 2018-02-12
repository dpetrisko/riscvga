`include "debug_defines.vh"
`include "rvga_types.vh"

module alu 
#(
    `include "rvga_params.vh"
)
(
	input rvga_word a,
	input rvga_word b,
	input rvga_aluop aluop,
	
	output rvga_word f
);

always @* begin
	case(aluop) 
		alu_passa: f = a;
		alu_passb: f = b;
		alu_add:   f = a + b;
		alu_slt:   f = ($signed(a) < $signed(b)) ? 1 : 0; 
		alu_sltu:  f = ($unsigned(a) < $unsigned(b)) ? 1 : 0;
		alu_and:   f = a & b;
		alu_or:    f = a | b;
		alu_xor:   f = a ^ b;
		alu_sll:   f = a << $unsigned(b[4:0]);
		alu_srl:   f = a >> $unsigned(b[4:0]);
		alu_sra:   f = a >>> $unsigned(b[4:0]);
		alu_sub:   f = a - b;
		
		default: f = 0;
	endcase
end

endmodule

