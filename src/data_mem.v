`timescale 1ns / 1ps
`include "define.v"
module data_mem (
           input clk,
           input[31:0] addr,
           input[31:0] wd,
           input we,
           output[31:0] rd
       );

reg[7:0] mem[`DATA_NUM:0];

assign rd = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};

always @(negedge clk) begin
    if (we) begin
        mem[addr] <= wd[7:0];
        mem[addr+1] <= wd[15:8];
        mem[addr+2] <= wd[23:16];
        mem[addr+3] <= wd[31:24];
    end
end
endmodule
