module decode (/*AUTOARG*/
   // Outputs
   rd1, rd2, imm_ext,
   // Inputs
   clk, pcp4d, inst
   ) ;
   input  clk;
   input [31:0] pcp4d, inst;
   output [31:0] rd1, rd2, imm_ext;
   
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
