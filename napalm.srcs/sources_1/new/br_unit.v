`timescale 1ns / 1ps
`include "def.vh"

module br_unit (
    input clk,
    input [31:0] rd1,  // beq要比较的两个操作数
    input [31:0] rd2,
    input [`BR_OP_LEN - 1 : 0] op, // 比较类型，或者直接跳转，或者不跳转
    input [31:0] pcp4,  // pc + 4
    input [31:0] imm_ext,  // TODO jump的target，应该传jump的偏移
    output [31:0] pc_jump,  // 如果要跳转/分支，地址应该是多少
    output jump  // 跳转不跳
);
  wire conditionSatisfied;
  assign condtionSatisfied = ;

  assign jump = (mode == `BR_OP_LEN'd0) ? 0 : 
  (mode == `BR_OP_ ) ? 1 :
  (conditionSatisfied) ? 1 : 0;

  wire [31:0] imm_sl2;
  assign imm_sl2 = {imm_ext[29 : 0], 2'b00};
  assign pc_jump = () ? {pcp4[31 : 0], imm_sl2} : 
  () ? (pcp4 + imm_sl2) : 31'd0;


    // beq, j ...
endmodule  // br_unit

