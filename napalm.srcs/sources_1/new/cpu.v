`timescale 1ns / 1ps


module cpu (
    input clk,  // 顶层模块唯二的两个输入
    input rst_n
);
  wire rst = ~rst_n;
endmodule
