`timescale 1ns / 1ps
`include "def.vh"

module execute (/*AUTOARG*/
   // Outputs
   res, data_wd_e, pc_jump, reg_wa_e, jump, overflow, regWriteEn, memWriteEn,
   // Inputs
   clk, rst, _aluOp, _srcAlu, _rd1, _rd2, _imm_ext, _pcp4f, sa, _regWriteEn,
   _memWriteEn
   ) ;
   input clk, rst;
   input [3:0] _aluOp;
   input _srcAlu;
   input  [31:0] _rd1, _rd2, _imm_ext, _pcp4f;
   input [4:0] sa;
   input _regWriteEn, _memWriteEn;
   output [31:0] res, data_wd_e, pc_jump;
   output [4:0]  reg_wa_e;
   output jump;
   output overflow;
   output reg regWriteEn, memWriteEn;

   reg [31:0] rd1, rd2, imm_ext, pcp4f;
   reg [3:0] aluOp;
   reg srcAlu;

   always @(posedge clk) begin
      if (rst) begin
         regWriteEn <= 0;
         memWriteEn <= 0;
         srcAlu <= `ALU_SRC_DEFAULT;
         aluOp <= 3'b0;
         // wbaddr
         // dmemwid
         rd1 <= 32'b0;
         rd2 <= 32'b0;
         imm_ext <= 32'b0;
      end else begin
         regWriteEn <= _regWriteEn;
         memWriteEn <= _memWriteEn;
         srcAlu <= `ALU_SRC_DEFAULT;
         aluOp <= _aluOp;
         // wbaddr
         // dmemwid
         rd1 <= _rd1;
         rd2 <= _rd2;
         imm_ext <= _imm_ext;
      end
   end   

   alu ALU (.num1(rd1), .num2((srcAlu == `ALU_SRC_EXTEND)? imm_ext: rd2), .sa(sa), res(res), .overflow(overflow));

   br_unit BR_UNIT (.aluOp(aluOp), .clk(clk), .rd1(rd1), .rd2(rd2), .pcp4(pcp4f), .imm_ext(imm_ext), .jump(jump), .pc_jump(pc_jump));
   
endmodule // execute
