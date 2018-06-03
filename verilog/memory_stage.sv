`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

module memory_stage
  ( input logic clk_i
    , input logic rst_i
    
    , input rvga_reg execute_rd
    , input rvga_word execute_result
    , input rvga_word execute_data
    , rvga_cword_s cword_i
    
    , output rvga_reg memory_rd
    , output rvga_word memory_result
    , rvga_cword_s cword_o
    
    , rvga_cachebus_if.master cachebus_io
    
    , input rvga_dword_s dword_i
    , output rvga_dword_s dword_o
    );

    dff #(.width($bits(rvga_dword_s))
          )
   debug (.clk_i(clk_i)
          ,.rst_i(rst_i)
          ,.w_v_i(1'b1)
          ,.data_i(dword_i)
          ,.data_o(dword_o)
          );

always_ff @(posedge clk_i) begin
  if (rst_i) begin
    memory_rd <= '0;
    memory_result <= '0;
    
    cword_o <= '0;
    cachebus_io.addr_o <= '0;
    cachebus_io.read_o <= '0;
    cachebus_io.write_o <= '0;
    cachebus_io.wdata_o <= '0;
  end else begin
    memory_rd <= execute_rd;
    memory_result <= cword_i.dcache_r_v ? cachebus_io.rdata_i : execute_result;
    
    cword_o <= cword_i;
    
    cachebus_io.addr_o <= execute_result;
    cachebus_io.read_o <= cword_i.dcache_r_v;
    cachebus_io.write_o <= cword_i.dcache_w_v;
    cachebus_io.wdata_o <= execute_data;
  end
end

always_comb begin

end

endmodule : memory_stage
