`timescale 1ns / 1ps


module reg_file (
    input         clk,
    input  [ 4:0] ra1, // 读地址1
    input  [ 4:0] ra2, // 读地址2
    input  [ 4:0] wa, // 写地址
    input         we, // 写么？
    input  [31:0] wd, // 写入的数据
    output [31:0] rd1, // 读出数据1
    output [31:0] rd2 // 读出数据2
);

  reg [31:1] gpr;
  reg [ 1:0] hilo;

  always @(posedge clk) begin
    if (we & wa != 5'b0) begin
      /* verilator lint_off WIDTH */
      gpr[wa] <= wd;
      /* verilator lint_on WIDTH */
    end
  end

endmodule
