`timescale 1ns / 1ps
module inst_mem (
           input clk,
           input[31:0] pc,
           output[31:0] inst
       );

reg[31:0] mem[255:0];

assign inst = mem[pc[31:2]]; // >> 4，因为我的基本单位是4字节，MIPS是1字节
endmodule
