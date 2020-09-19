`timescale 1ns / 1ps


module writeback (/*AUTOARG*/
   // Outputs
   reg_wa_w, reg_wd,
   // Inputs
   data_rd_w, res_w
   ) ;
   input  [31:0] data_rd_w, res_w;
   output [4:0] reg_wa_w;
   output [31:0] reg_wd;
   
   // 给decode的register file
endmodule // writeback
