module mux #(parameter els_p = 2
             , parameter width_p = 1
	     )
  ( input logic [$clog2(els_p)-1:0] sel_i
    , input logic [els_p-1:0][width_p-1:0] i

   , output logic [width_p-1:0] o
   );
   
  assign o = i[sel_i];

endmodule : mux

