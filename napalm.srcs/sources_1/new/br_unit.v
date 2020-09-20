`timescale 1ns / 1ps
`include "def.vh"

module br_unit (
    input clk,
    input [31:0] rd1,  // beq要比较的两个操作�?
    input [31:0] rd2,
    input [`BR_OP_LEN - 1 : 0] mode,  // 比较类型，或者直接跳转，或�?�不跳转
    input [31:0] pcp4,  // pc + 4
    input [31:0] imm_ext,  // TODO jump的target，应该传jump的偏�?
    output [31:0] pc_jump,  // 如果要跳�?/分支，地�?应该是多�?
    output jump  // 跳转不跳
);
  wire conditionSatisfied;
  assign condtionSatisfied = ((mode == `BR_OP_GREATER && rd1 > rd2) ||
  (mode == `BR_OP_GREATER_EQ && rd1 >= rd2) || 
  (mode == `BR_OP_EQUAL && rd1 == rd2) || 
  (mode == `BR_OP_NOT_EQUAL && rd1 != rd2) || 
  (mode == `BR_OP_LESS && rd1 < rd2) || 
(mode == `BR_OP_LESS_EQ && rd1 <= rd2)) ? 1 : 0;

  assign jump = (mode == `BR_OP_DEFAULT) ? 0 : 
  (mode == `BR_OP_DIRECTJUMP || mode == `BR_OP_REG) ? 1 :
  (conditionSatisfied) ? 1 : 0;

  wire [31:0] imm_sl2;
  assign imm_sl2 = (mode == `BR_OP_REG) ? rd1 : {imm_ext[29 : 0], 2'b00};
  assign pc_jump = (mode == `BR_OP_DIRECTJUMP || mode == `BR_OP_REG) ? {pcp4[31 : 28], imm_sl2[27:0]} : 
  (conditionSatisfied) ? (pcp4 + imm_sl2) : 32'd0;
endmodule  // br_unit

