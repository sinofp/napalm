`timescale 1ns / 1ps
`include "def.vh"

module execute (
    input clk,
    input rst,
    input [3:0] _aluOp,  // alu到底是加减乘除
    input _srcAlu,  // rd2还是imm——可以放到decode，也可以放在这
    input [31:0] _rd1,  // 寄存器读出的第一个数
    input [31:0] _rd2,
    input [31:0] _imm_ext,  // 扩张的立即数
    input  [31:0] _pcp4f, // pc+4，现在br unit在执行阶段，但放回去就不用了。放回还有个前提，是前推单元也得提前到decode
    input [4:0] sa,  // alu位移运算的偏移量
    input _regWriteEn,  // 新来的指令要不要写入寄存器
    input _memWriteEn,  // 新来的指令要不要写入data mem
    input _stall,
    output [31:0] res,  // alu运算结果。支持乘法除法的话，应该改成64位
    output [31:0] data_wd_e,  // 要写入存储器的话，写入什么内容
    output [4:0] reg_wa_e,  // 寄存器写入地址，对应前面的output [1:0]  writeRegDst
    output [31:0] pc_jump,  // 跳转到的地址，br unit输出
    output jump,  // 这条指令是否跳转，br unit的输出
    output overflow,  // addiu和addi的区别
    output reg regWriteEn,  // 这条指令要不要写入寄存器
    output reg memWriteEn  // 这条指令要不要写入data mem
);

  reg [31:0] rd1, rd2, imm_ext, pcp4f;
  reg [3:0] aluOp;
  reg srcAlu;

  always @(posedge clk) begin
    if (rst | _stall) begin
      // stall时直接让alu休息一周期
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

  alu ALU (
      .aluOp(aluOp),
      .num1(rd1),
      .num2((srcAlu == `ALU_SRC_EXTEND) ? imm_ext : rd2),
      .sa(sa),
      .res(res),
      .overflow(overflow)
  );

  br_unit BR_UNIT (
      .clk(clk),
      .rd1(rd1),
      .rd2(rd2),
      .pcp4(pcp4f),
      .imm_ext(imm_ext),
      .jump(jump),
      .pc_jump(pc_jump)
  );

endmodule  // execute
