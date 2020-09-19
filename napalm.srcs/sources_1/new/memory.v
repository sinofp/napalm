`timescale 1ns / 1ps


module memory (/*AUTOARG*/
   // Outputs
   data_rd, res_w, reg_wa_w,
   // Inputs
   res_m, data_wd_m, reg_wa_m
   ) ;
   input  [31:0] res_m, data_wd_m;
   input [4:0]   reg_wa_m;
   output [31:0] data_rd, res_w;
   output [4:0]       reg_wa_w;

   assign reg_wa_w = reg_wa_m;
   assign res_w = res_m;

endmodule // memory
