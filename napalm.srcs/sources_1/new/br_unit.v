`timescale 1ns / 1ps

module br_unit (
    input clk,
    input [31:0] rd1,  // beq要比较的两个操作数
    input [31:0] rd2,
    input [31:0] pcp4,  // pc + 4
    input [31:0] imm_ext,  // TODO jump的target，应该传jump的偏移
    output [31:0] pc_jump,  // 如果要跳转/分支，地址应该是多少
    output jump  // 跳转不跳
);

  // beq, j ...
endmodule  // br_unit

