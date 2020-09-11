`timescale 1ns / 1ps
module alu (
           input alu_op,
           input[31:0] num1,
           input[31:0] num2,
           output[31:0] res
       );

assign res = (alu_op == 1'b0)? num1 + num2: num1 & num2;
endmodule
