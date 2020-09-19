`timescale 1ns / 1ps


module decode (/*AUTOARG*/
   // Outputs
   rd1, rd2, imm_ext, pcp4f, aluOp, srcAlu, pcp4d, regWriteEn, memWriteEn, link,
   jumpOp, extendOp, writeRegDst, srcReg, saveRetAddrEn,
   // Inputs
   clk, _pcp4d, _inst
   ) ;
   input  clk;
   input [31:0] _pcp4d, _inst;
   output [31:0] rd1, rd2, imm_ext, pcp4f;

   wire [ 4:0]   ra1;
   wire [ 4:0]   ra2;
   wire [ 4:0]   wa;
   wire          we;
   wire [31:0]   wd;
   wire [31:0]   rd1;
   wire [31:0]   rd2;
   
   output [3:0]  aluOp;
   output        srcAlu;
   output [31:0] rd1, rd2, imm_ext, pcp4d;
   // output [4:0] sa;
   output        regWriteEn, memWriteEn;
   output        link;
   output [2:0]  jumpOp;
   output [1:0]  extendOp;
   output [1:0]  writeRegDst;
   output        srcAlu;
   output [2:0]  srcReg;

   output        saveRetAddrEn;

   reg [31:0]    inst, pcp4d;

   always @(posedge clk) begin
      if (rst) begin
         inst <= 32'b0;
         pcp4d <= 32'b0;
      end else begin
         inst <= _inst;
         pcp4d <= _pcp4d;
      end
   end
  
   cu CU (.inst(inst),
          .jumpOp(jumpOp),  
          .extendOp(extendOp),  
          .regWriteEn(regWriteEn),  
          .memWriteEn(memWriteEn),  
          .aluOp(aluOp),  
          .writeRegDst(reg_wa),  
          .srcAlu(srcAlu),  
          .srcReg(srcReg),  
          .saveRetAddrEn(link));

   reg_file REG_FILE (.clk(clk),
                      .ra1(ra1),
                      .ra2(ra2),
                      .wa(wa),
                      .we(we),
                      .wd(wd),
                      .rd1(rd1),
                      .rd2(rd2));

endmodule // decode
