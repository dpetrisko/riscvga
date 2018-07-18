`include "rvga_types.sv"
import rvga_types::*;

module regfile #(parameter width_p = 32
                 , parameter els_p = 32
		         )
  ( input logic clk_i
    , input logic rst_i

    , input logic rd_w_v_i
    , input logic[$clog2(els_p)-1:0] rd_i
    , input logic[width_p-1:0] rd_data_i

    , input logic[$clog2(els_p)-1:0] rs1_i
    , output logic[width_p-1:0] rs1_data_o

    , input logic[$clog2(els_p)-1:0] rs2_i
    , output logic[width_p-1:0] rs2_data_o
    );

logic[width_p-1:0] phys_r[els_p-1:0];

initial begin
  for(integer i = 0; i < els_p; i++) begin
    phys_r[i] = i;
  end
end

always_comb begin
  rs1_data_o = (rd_w_v_i && (rs1_i == rd_i)) ? rd_data_i : phys_r[rs1_i];
  rs2_data_o = (rd_w_v_i && (rs2_i == rd_i)) ? rd_data_i : phys_r[rs2_i];
end

always_ff @(posedge clk_i) begin
  if (rst_i) begin
    for (integer i = 0; i < els_p; i++) begin
      phys_r[i] <= i;
    end
  end else if (rd_w_v_i) begin
    phys_r[rd_i] <= (rd_i == 0) ? 0 : rd_data_i;
  end
end

endmodule : regfile

