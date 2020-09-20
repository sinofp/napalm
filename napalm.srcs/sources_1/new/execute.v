`timescale 1ns / 1ps
`include "def.vh"

module execute (
    input clk,
    input rst,
    input [3:0] _alu_op,  // alu到底是加减乘除
    input _src_alu,  // rd2还是imm——可以放到decode，也可以放在这
    input [31:0] _rd1,  // 寄存器读出的第一个数
    input [31:0] _rd2,
    input [31:0] _imm_ext,  // 扩张的立即数
    input [31:0] _pcp8, // pc+4，现在br unit在执行阶段，但放回去就不用了。放回还有个前提，是前推单元也得提前到decode
    input [4:0] _reg_write_addr,  // 寄存器写入地址，在decode中已被计算
    // DELETED input [4:0] sa,  // alu位移运算的偏移量
    input [5:0] _op_code, // 操作码，用于lb等访存操作
    input [2:0] _reg_wd_mux, // reg写回的数据来源
    input _reg_we,  // 新来的指令要不要写入寄存器
    input _mem_we,  // 新来的指令要不要写入data mem
    input _stall,
    output [4:0] reg_write_addr,  // （传递）寄存器写入地址，在decode中已被计算
    output [31:0] imm_ext,  // （传递）扩张的立即数
    output [31:0] alu_res,  // alu运算结果。支持乘法除法的话，应该改成64位
    output [31:0] rd2, // （传递）可能给reg_wd
    output [2:0] reg_wd_mux // （传递）reg写回的数据来源
    output [5:0] op_code, // （传递）操作码，用于lb等访存操作
    output [31:0] pcp8, // （传递）pc+4，现在br unit在执行阶段，但放回去就不用了。放回还有个前提，是前推单元也得提前到decode
    // DELETED output [31:0] data_wd_e,  // 要写入存储器的话，写入什么内容
    
    // DELETED output [31:0] pc_jump,  // 跳转到的地址，br unit输出
    // DELETED output jump,  // 这条指令是否跳转，br unit的输出
    output overflow,  // addiu和addi的区别
    output reg reg_we,  // （传递）这条指令要不要写入寄存器
    output reg mem_we  // （传递）这条指令要不要写入data mem
);

  reg [31:0] rd1, rd2, imm_ext, pcp8;
  reg [3:0] alu_op;
  reg [4:0] reg_write_addr;
  reg [2:0] reg_wd_mux;
  reg [5:0] op_code;
  reg src_alu;

  always @(posedge clk) begin
    if (rst | _stall) begin
      rd1 <= 32'b0;
      rd2 <= 32'b0;
      imm_ext <= 32'b0;
      pcp8 <= 32'b0;
      alu_op <= 3'b0;
      reg_write_addr <= 4'b0;
      reg_wd_mux <= 2'b0;
      op_code <= 5'b0;
      reg_we <= 1'b0;
      mem_we <= 1'b0;
      _src_alu <= 1'b0;

    end else begin
      rd1 <= _rd1;
      rd2 <= _rd2;
      imm_ext <= _imm_ext;
      pcp8 <= _pcp8;
      alu_op <= _alu_op;
      reg_write_addr <= _reg_write_addr;
      reg_wd_mux <= _reg_wd_mux;
      op_code <= _op_code;
      reg_we <= _reg_we;
      mem_we <= _mem_we;
      src_alu <= _src_alu;
    end
  end

  alu ALU (
      .alu_op(alu_op),
      .num1(rd1),
      .num2((src_alu == `ALU_SRC_EXTEND) ? imm_ext : rd2),
      .sa(sa),
      .res(res),
      .overflow(overflow)
  );
  ;

endmodule  // execute
