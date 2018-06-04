`include "debug_defines.sv"
`include "rvga_defines.sv"
`include "rvga_types.sv"
import rvga_types::*;

module regfile #(parameter width_p = 32
                 , parameter reg_els_p = 32)
  ( input logic clk_i
    , input logic rst_i
    
    , input logic rd_w_v_i
    
    , input logic[$clog2(reg_els_p)-1:0] rs1_i
    , input logic[$clog2(reg_els_p)-1:0] rs2_i
    , input logic[$clog2(reg_els_p)-1:0] rd_i
    
    , output logic[width_p-1:0] data_rs1_o
    , output logic[width_p-1:0] data_rs2_o
    , input logic[width_p-1:0] data_rd_i
    );

logic[width_p-1:0] physical_r[reg_els_p-1:0];

initial begin
  for(integer i = 0; i < reg_els_p; i++) begin
    physical_r[i] <= 0;
  end
end

always_ff @(posedge clk_i) begin
  if(rst_i) begin
    data_rs1_o <= '0;
    data_rs2_o <= '0;
  end else begin
    data_rs1_o <= (rd_w_v_i && (rs1_i == rd_i)) ? data_rd_i : physical_r[rs1_i];
    data_rs2_o <= (rd_w_v_i && (rs2_i == rd_i)) ? data_rd_i : physical_r[rs2_i];
      
    if (rd_w_v_i) begin
      physical_r[rd_i] <= (rd_i == 0) ? 0 : data_rd_i;
    end
  end
end

endmodule : regfile

