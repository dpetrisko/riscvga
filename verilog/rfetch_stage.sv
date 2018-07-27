`include "rvga_types.sv"
import rvga_types::*;

module rfetch_stage
  (input logic clk_i
   , input logic rst_i
   
   , input logic stall_v_i
   
   , input rvga_cword cword_i
   , output rvga_cword cword_o
   
   , input rvga_reg rd_i
   , input rvga_word rd_data_i 
   , input logic rd_w_v_i
   
   , input logic[31:7] imm_raw_i
   
   , output rvga_word imm_data_o
   , output rvga_word rs1_data_o
   , output rvga_word rs2_data_o
   
   , output logic br_v_o
   );
   
rvga_cword cword_n, cword_r;
logic[31:7] imm_raw_n, imm_raw_r;
            
  regfile #(.width_p($bits(rvga_word))
            ,.els_p(32)
            ,.zero_init_p('1)
            )
   regfile (.clk_i(clk_i)
            ,.rst_i(rst_i)
                  
            ,.rd_w_v_i(rd_w_v_i)
            ,.rd_i(rd_i)
            ,.rd_data_i(rd_data_i)
                   
            ,.rs1_i(cword_r.rs1)
            ,.rs1_data_o(rs1_data_o)
                   
            ,.rs2_i(cword_r.rs2)
            ,.rs2_data_o(rs2_data_o)
            );
            
     dff #(.width_p($bits(logic[31:7])))
  imm_raw (.clk_i(clk_i)
           ,.rst_i(rst_i)
           ,.w_v_i(~stall_v_i)
           
           ,.i(imm_raw_n)
           ,.o(imm_raw_r)
           );
            
imm_construct #()
  imm_construct(.inst_type_i(cword_r.inst_type)
                ,.imm_raw_i(imm_raw_r[31:7])
                ,.shift_v_i(cword_r.shift_v)
            
                ,.imm_o(imm_data_o)
                );
                
 dff #(.width_p($bits(rvga_cword))
       ) 
cword (.clk_i(clk_i)
      ,.rst_i(rst_i)
      ,.w_v_i(~stall_v_i)
       
      ,.i(cword_n)
      ,.o(cword_r)
      );

always_comb begin
  cword_n = cword_i;

  cword_o = cword_r;
  
  imm_raw_n = imm_raw_i;
  
  br_v_o = cword_r.br_v;
end

endmodule : rfetch_stage

