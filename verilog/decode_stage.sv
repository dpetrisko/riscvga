`include "rvga_types.sv"
import rvga_types::*;

module decode_stage
  (input logic clk_i
   , input logic rst_i
   
   , input logic stall_v_i
   , input logic bubble_v_i
   
   , input rvga_word pc_i
   , input logic inst_v_i
   , input rvga_word inst_i
   
   , output rvga_cword cword_o
  
   , output logic[31:7] imm_raw_o
   , output logic br_v_o
   );
   
rvga_cword decoded;
rvga_word ir_n, ir_r;
logic ir_v_r;
rvga_word rvga_nop;

dff #(.width_p($bits(rvga_word))
      ,.reset_val_p(32'h13)
      )
  ir(.clk_i(clk_i)
       ,.rst_i(rst_i)
       
       ,.i(ir_n)
       ,.w_v_i(~stall_v_i)
       ,.o(ir_r)
       );
       
  dff #(.width_p((1)))
 inst_v(.clk_i(clk_i)
        ,.rst_i(rst_i)
      
        ,.i(inst_v_i)
        ,.w_v_i(~stall_v_i)
        ,.o(ir_v_r)
        );
       
 mux #(.els_p(2)
       ,.width_p($bits(rvga_word))
       )
 irmux(.sel_i(bubble_v_i)
       ,.i({rvga_nop, inst_i})
       ,.o(ir_n)
       );
             
 inst_decoder #()
       decoder (.pc_i(pc_i)
                ,.ir_v_i(ir_v_r)
                ,.ir_i(ir_r)

                ,.decoded_o(decoded)
                );

always_comb begin
  rvga_nop = 32'b0000_0000_0000_0000_0000_0000_0001_0011;
  cword_o = decoded;
  
  imm_raw_o = ir_r[31:7];

  br_v_o = decoded.br_v | decoded.jmp_v;
end

endmodule : decode_stage
