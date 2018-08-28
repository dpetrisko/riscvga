import rvga_types::*;

module execute_stage
  (input logic clk_i
   , input logic rst_i
   
   , input logic stall_v_i
   
   , input rvga_cword cword_i
   
   , input rvga_word imm_data_i
   , input rvga_word rs1_data_i
   , input rvga_word rs2_data_i
                  
   , input logic forward_memory_execute_rs1_v_i
   , input logic forward_memory_execute_rs2_v_i
   , input logic forward_writeback_execute_rs1_v_i
   , input logic forward_writeback_execute_rs2_v_i 
   
   , input rvga_word memory_rd_data_i
   , input rvga_word writeback_rd_data_i
      
   , output rvga_word alu_result_o
   , output logic bru_result_o
   , output rvga_word st_data_o
   
   , output logic br_v_o
   );
   
rvga_word rs1_mux_o, rs2_mux_o;
rvga_word alua_mux_o, alub_mux_o;
rvga_word imm_data_r, rs1_data_r, rs2_data_r;


    mux #(.els_p(4)
          ,.width_p($bits(rvga_word))
          )
 rs1_mux (.sel_i({forward_memory_execute_rs1_v_i, forward_writeback_execute_rs1_v_i})
          ,.i({memory_rd_data_i, memory_rd_data_i, writeback_rd_data_i, rs1_data_r})
          ,.o(rs1_mux_o)
          );
         
    mux #(.els_p(4)
          ,.width_p($bits(rvga_word))
          )
 rs2_mux (.sel_i({forward_memory_execute_rs2_v_i, forward_writeback_execute_rs2_v_i})
          ,.i({memory_rd_data_i, memory_rd_data_i, writeback_rd_data_i, rs2_data_r})
          ,.o(rs2_mux_o)
          );
             
mux #(.els_p(2)
      ,.width_p($bits(rvga_word))
      )
amux (.sel_i(cword_i.addpc_v)
      ,.i({cword_i.pc, rs1_mux_o})
      ,.o({alua_mux_o})
      );
      
mux #(.els_p(4)
      ,.width_p($bits(rvga_word))            
      )
bmux (.sel_i({cword_i.imm_v, cword_i.shift_v})
      ,.i({imm_data_r, imm_data_r, {27'b0, rs2_mux_o[4:0]}, rs2_mux_o})
      ,.o({alub_mux_o})
      );

rvga_alu #()
      alu (.a_i(alua_mux_o)
           ,.b_i(alub_mux_o)
           ,.op_i(cword_i.funct3)
           ,.alt_i(cword_i.funct7[5])
           ,.addr_calc_v_i(cword_i.addpc_v || cword_i.dmem_r_v || cword_i.dmem_w_v)
           
           ,.o(alu_result_o)
           );
           
 rvga_bru #()
       bru (.a_i(rs1_mux_o)
            ,.b_i(rs2_mux_o)
            ,.op_i(cword_i.funct3)
            
            ,.o(bru_result_o)
            );
        
     dff #(.width_p($bits(rvga_word))) 
 rs1_data (.clk_i(clk_i)
           ,.rst_i(rst_i)
           ,.w_v_i(~stall_v_i)
         
           ,.i(rs1_data_i)
           ,.o(rs1_data_r)
           );
         
     dff #(.width_p($bits(rvga_word))) 
 rs2_data (.clk_i(clk_i)
           ,.rst_i(rst_i)
           ,.w_v_i(~stall_v_i)
           
           ,.i(rs2_data_i)
           ,.o(rs2_data_r)
           );
           
     dff #(.width_p($bits(rvga_word))) 
 imm_data (.clk_i(clk_i)
           ,.rst_i(rst_i)
           ,.w_v_i(~stall_v_i)
       
           ,.i(imm_data_i)
           ,.o(imm_data_r)
           );
           
always_comb begin
  br_v_o = cword_i.br_v | cword_i.jmp_v;
  st_data_o = rs2_mux_o;
end


endmodule : execute_stage

