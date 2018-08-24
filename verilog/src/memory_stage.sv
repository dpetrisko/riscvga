import rvga_types::*;

module memory_stage
  (input logic clk_i
   , input logic rst_i
   
   , input logic stall_v_i
   
   , input rvga_cword cword_i
   , output rvga_cword cword_o
   
   , input rvga_dword dword_i
   , output rvga_dword dword_o
   
   , input rvga_word alu_result_i
   , input logic bru_result_i
   , input rvga_word st_data_i
   
   , output logic dmem_r_v_o
   , output logic dmem_w_v_o
   , output rvga_word dmem_addr_o
   , input rvga_word dmem_data_i
   , output rvga_word dmem_data_o   
   
   , output logic btaken_o
   , output rvga_word alu_or_ld_result_o   
   
   , output logic br_v_o  
   );
 
 rvga_cword cword_n, cword_r;
 rvga_dword dword_n, dword_r;
 rvga_word st_data_n, st_data_r;
 logic bru_result_n, bru_result_r;
 rvga_word alu_result_r;
 rvga_word ld_result;
 
    mux #(.els_p(2)
          ,.width_p($bits(rvga_word))
          )
result_mux(.sel_i(cword_r.dmem_r_v)
          ,.i({ld_result, alu_result_r})
          ,.o(alu_or_ld_result_o)
          );    
                  
   dff #(.width_p($bits(rvga_cword)))
  cword (.clk_i(clk_i)
        ,.rst_i(rst_i)
        ,.w_v_i(~stall_v_i)
         
        ,.i(cword_n)
        ,.o(cword_r)
        );
        
   dff #(.width_p($bits(rvga_dword)))
  dword (.clk_i(clk_i)
         ,.rst_i(rst_i)
         ,.w_v_i(~stall_v_i)
        
         ,.i(dword_n)
         ,.o(dword_r)
         );
        
  memory_slicer #()
           slicer(.ld_data_i(dmem_data_i)
                  ,.st_data_i(st_data_r)
                 
                  ,.op_i(cword_r.funct3)
                 
                  ,.ld_result_o(ld_result)
                  ,.st_result_o(dmem_data_o)
                  );
             
        dff #(.width_p($bits(rvga_word)))
  alu_result(.clk_i(clk_i)
              ,.rst_i(rst_i)
              ,.w_v_i(~stall_v_i)
              
              ,.i(alu_result_i)
              ,.o(alu_result_r)
              );
              
      dff #(.width_p($bits(rvga_word)))
    st_data(.clk_i(clk_i)
            ,.rst_i(rst_i)
            ,.w_v_i(~stall_v_i)
                
            ,.i(st_data_n)
            ,.o(st_data_r)
            );

      dff #(.width_p(1))
 bru_result(.clk_i(clk_i)
            ,.rst_i(rst_i)
            ,.w_v_i(~stall_v_i)
                
            ,.i(bru_result_n)
            ,.o(bru_result_r)
            );      
        
always_comb begin
  cword_n = cword_i;
  dword_n = dword_i;
  st_data_n = st_data_i;
  bru_result_n = bru_result_i;
  
  dword_n.alu_result = alu_result_i;
  
  cword_o = cword_r;
  dword_o = dword_r;
  
  dmem_r_v_o = cword_r.dmem_r_v;
  dmem_w_v_o = cword_r.dmem_w_v;
  dmem_addr_o = alu_result_r;
  
  btaken_o = cword_r.jmp_v || (cword_r.br_v && bru_result_r);
  
  br_v_o = cword_r.jmp_v || cword_r.br_v;
end

endmodule : memory_stage

