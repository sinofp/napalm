`timescale 1ns / 1ps


module decode (/*AUTOARG*/
   // Outputs
   rd1, rd2, imm_ext, pcp4f,
   // Inputs
   clk, pcp4d, inst
   ) ;
   input  clk;
   input [31:0] pcp4d, inst;
   output [31:0] rd1, rd2, imm_ext, pcp4f;

   assign pcp4f = pcp4d;

    wire         clk;
    wire  [ 4:0] ra1;
    wire  [ 4:0] ra2;
    wire  [ 4:0] wa;
    wire         we;
    wire  [31:0] wd;
    wire [31:0] rd1;
    wire [31:0] rd2;
   
   cu CU ();

   reg_file REG_FILE (.clk(clk),
                      .ra1(ra1),
                      .ra2(ra2),
                      .wa(wa),
                      .we(we),
                      .wd(wd),
                      .rd1(rd1),
                      .rd2(rd2));
   
endmodule // decode
