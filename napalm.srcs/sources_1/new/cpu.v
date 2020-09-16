`timescale 1ns / 1ps


module cpu(
           input clk,
           input rst_n
       );
wire rst = ~ rst_n;
endmodule
