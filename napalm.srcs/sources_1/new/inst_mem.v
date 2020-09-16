`timescale 1ns / 1ps


module inst_mem(
           input         clk,
           input [31:0]  pc,
           output [31:0] inst
       );

reg [31:0]                 mem[255:0];
assign inst = mem[pc[31:2]];
endmodule
