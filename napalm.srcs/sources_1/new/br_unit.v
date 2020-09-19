`timescale 1ns / 1ps

module br_unit (/*AUTOARG*/
   // Outputs
   pc_jump, jump,
   // Inputs
   rd1, rd2, pcp4, imm_ext
   ) ;
   input  [31:0] rd1, rd2, pcp4, imm_ext;
   output [31:0] pc_jump;
   output jump;

   // beq, j ...
endmodule // br_unit

