`timescale 1ns / 1ps


module execute (/*AUTOARG*/
   // Outputs
   res, data_wd_e, pc_jump, reg_wa_e, jump,
   // Inputs
   rd1, rd2, imm_ext, pcp4f
   ) ;
   input  [31:0] rd1, rd2, imm_ext, pcp4f;
   output [31:0] res, data_wd_e, pc_jump;
   output [4:0]  reg_wa_e;
   output jump;

   alu ALU ();

   br_unit BR_UNIT (.clk(clk), .rd1(rd1), .rd2(rd2), .pcp4(pcp4f), .imm_ext(imm_ext), .jump(jump), .pc_jump(pc_jump));
   
endmodule // execute
