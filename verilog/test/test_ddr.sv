import rvga_types::*;

module test_ddr #(parameter use_program_p = 0
                  , use_identity_p = 0
                  , debug_p = 0
                  )
  ( input logic clk_i
	, input logic rst_i
	
	, input logic r_v_i
	, input logic w_v_i
	, input rvga_word addr_i
	, output rvga_word data_o
	, input rvga_word data_i
	, output logic resp_v_o
);

localparam ELF_SIZE=16384;
string filename;
logic[7:0] mem_array[0:ELF_SIZE-1];

always_comb begin  
  data_o = {mem_array[addr_i+3], mem_array[addr_i+2], mem_array[addr_i+1], mem_array[addr_i+0]};
  resp_v_o = (r_v_i | w_v_i);
end

always_ff @(posedge clk_i) begin
  if(rst_i) begin
    if(use_program_p) begin
      if($value$plusargs("TEST_PROG=%s", filename)) begin
        if(filename.len() == 0) begin
          $error("TEST_PROG not set");
          $finish();
        end else begin
          $readmemh(filename, mem_array, 0, ELF_SIZE-1);
        end
      end
      if(debug_p) begin
        $display("---------------- BEGIN MEMORY DUMP ----------------");
        for(integer i = 0; i < ELF_SIZE; i=i+4) begin
          $display("ADDR: %x DATA: %x", i, {mem_array[i+3],mem_array[i+2],mem_array[i+1],mem_array[i+0]});
        end
        $display("---------------- END MEMORY DUMP ----------------");
      end
    end 
    else if(use_identity_p) begin
      for(integer i = 0; i < ELF_SIZE; i=i+4) begin
        mem_array[i] = i[7:0];
        mem_array[i+1] = i[15:8];
        mem_array[i+2] = i[23:16];
        mem_array[i+3] = i[31:24];
      end
    end
  end else if(w_v_i) begin
    mem_array[addr_i+0] <= data_i[7:0];
    mem_array[addr_i+1] <= data_i[15:8];
    mem_array[addr_i+2] <= data_i[23:16];
    mem_array[addr_i+3] <= data_i[31:24];
  end
end

always_ff @(posedge clk_i) begin
  if(debug_p) begin
    if(r_v_i) begin
      $display("READ MEM[%x] (%x)", addr_i, data_o);             
    end else if(w_v_i) begin
      $display("WRITE MEM[%x] = (%x)", addr_i, data_i);
    end
  end
end

endmodule : test_ddr

