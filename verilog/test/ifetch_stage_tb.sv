module ifetch_stage_tb;

logic clk;
logic rst;

logic[31:0] cycle;

logic imem_r_v;
logic[31:0] imem_addr;
logic[31:0] imem_data;
logic imem_resp;

logic[31:0] ir;

logic[31:0] old_addr;

logic br_v;
logic[31:0] br_tgt;

logic ifetch_flush_v;
logic ifetch_stall_v;

ifetch_stage #()
  ifetch_stage(.clk_i(clk)
             ,.rst_i(rst)
             
             ,.imem_addr_o(imem_addr)
             ,.imem_data_i(imem_data)
             
             ,.stall_v_i(ifetch_stall_v)
             ,.flush_v_i(ifetch_flush_v)
             
             ,.ir_o(ir)
             
             ,.br_v_i(br_v)
             ,.br_tgt_i(br_tgt)
             );
             
test_ddr #(.use_identity_p(1)
           )
     iddr (.clk_i(clk)
           ,.rst_i(rst)
           
           ,.r_v_i(1'b1)
           ,.w_v_i(1'b0)
           ,.addr_i(imem_addr)
           ,.data_o(imem_data)
           ,.data_i(32'b0)
           ,.resp_v_o(imem_resp)
           );
             
initial begin
   clk = 0;
   rst = 1;
   cycle = 0;
   #8 rst = 0;
end

always begin 
  #5 clk = ~clk; 
end

logic[31:0] randevent;
logic[31:0] btarget;

logic old_btaken;
logic[31:0] old_br_tgt;

logic old_stall;
logic old_flush;

logic[31:0] rvga_nop = 32'b0000_0000_0000_0000_0000_0000_0001_0011;

always @(posedge clk) begin
  cycle <= cycle + 1;
  
  randevent <= $urandom()%100;
  if (randevent < 10) begin
    br_v <= 'b1;
    br_tgt <= ($urandom()%1000);
  end else if (randevent < 20) begin
    ifetch_stall_v <= 'b1;
  end else if (randevent < 30) begin
    ifetch_flush_v <= 'b1;
  end else begin
    br_v <= 'b0;
    br_tgt <= 'b0;
    ifetch_stall_v <= 'b0;
    ifetch_flush_v <= 'b0;
  end
  
  old_flush <= ifetch_flush_v;
  old_stall <= ifetch_stall_v;
  old_btaken <= br_v;
  old_addr <= imem_addr;
  old_br_tgt <= br_tgt;
  
  /* Check that branch is taken, with a few cycle warmup */
  if (cycle > 3) begin
    if (old_flush) begin
      /* Check that a nop is emitted when flushed */
      assert (rvga_nop == ir);
    end else if (old_stall) begin
      /* Check that pc does not change when stalled */
      assert (imem_addr == old_addr);
    end else if (old_btaken) begin
      /* Check that pc updates to branch target */
      assert (imem_addr == old_br_tgt);
    end else begin
      /* Check that 'instruction' is fetched without stall, with a few cycle warmup */
      assert (old_addr == ir);
    end
  end
end           

endmodule : ifetch_stage_tb

