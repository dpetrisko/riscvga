`include "rvga_types.svh"

module icache_control
#(parameter num_sets = 4)
(
    input logic clk,
    input logic rst,
    
    input logic ifetch_icache_read,
    output logic icache_ifetch_resp,
    
    output logic icache_iddr_read,
    input logic iddr_icache_resp,
    
    input logic icache_hit,
    output logic[num_sets-1:0] icache_load
);

enum {idle, miss} state, next_state;

always_ff @(posedge clk) begin
    state <= next_state;
end

always_comb begin
    icache_load = 4'b0000;
    icache_ifetch_resp = 1'b0;
    icache_iddr_read = 1'b0;
    next_state = idle;

    case(state) 
        idle: begin
            if(ifetch_icache_read && icache_hit) begin
                icache_ifetch_resp = 1'b1;
            end else if(ifetch_icache_read && ~icache_hit) begin
                icache_iddr_read = 1'b1;
                next_state = miss;
            end 
        end
        
        miss: begin
            if(ifetch_icache_read && ~iddr_icache_resp) begin
                icache_iddr_read = 1'b1;
                next_state = miss;
            end else if(ifetch_icache_read && iddr_icache_resp) begin
                icache_load = 4'b0001;
            end
        end
    endcase
end

endmodule : icache_control
