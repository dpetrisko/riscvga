`include "rvga_types.sv"
import rvga_types::*;

module rvga_tb;

logic clk;
logic rst;

rvga_word imem_addr;
rvga_word imem_data;
logic imem_resp_v;

logic dmem_r_v;
logic dmem_w_v;
rvga_word dmem_addr;
rvga_word dmem_rdata;
rvga_word dmem_wdata;
logic dmem_resp_v;

rvga_writeback_cword debug_cword;
logic debug_cword_v;

rvga_top #() 
processor (.clk_i(clk)
           ,.rst_i(rst)
           
           ,.imem_addr_o(imem_addr)
           ,.imem_data_i(imem_data)
           ,.imem_resp_v_i(imem_resp_v)
           
           ,.dmem_r_v_o(dmem_r_v)
           ,.dmem_w_v_o(dmem_w_v)
           ,.dmem_addr_o(dmem_addr)
           ,.dmem_data_i(dmem_rdata)
           ,.dmem_data_o(dmem_wdata)
           ,.dmem_resp_v_i(dmem_resp_v)
           
           ,.debug_cword_o(debug_cword)
           ,.debug_cword_v_o(debug_cword_v));

test_ddr #(.use_program_p(1)
           )
     iddr (.clk_i(clk)
           ,.rst_i(rst)
           
           ,.r_v_i('1)
           ,.w_v_i('0)
           ,.addr_i(imem_addr)
           ,.data_o(imem_data)
           ,.data_i('0)
           ,.resp_v_o(imem_resp_v)
           );

test_ddr #(.use_identity_p(1)
           ,.debug_p(1)
           )
     dddr (.clk_i(clk)
           ,.rst_i(rst)
           
           ,.r_v_i(dmem_r_v)
           ,.w_v_i(dmem_w_v)
           ,.addr_i(dmem_addr)
           ,.data_o(dmem_rdata)
           ,.data_i(dmem_wdata)
           ,.resp_v_o(dmem_resp_v)
           );
           
rvga_nonsynth_monitor #()
               monitor (.clk_i(clk)
                        ,.debug_word_i(debug_cword)
                        ,.debug_word_v_i(debug_cword_v)
                        );

integer cycle = 0;

initial begin
  clk = 0;
  rst = 1;
  #8 rst = 0;
end

always begin 
  #5 clk = ~clk; 
  cycle = cycle + 1;

  if(cycle >= 100000) begin
    $finish;
  end
end

endmodule 
