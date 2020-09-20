`timescale 1ns / 1ps


module inst_mem (
    input         clk,
    input  [31:0] pc,
    output [31:0] inst
);

  reg [31:0] mem[64:0];
  /* verilator lint_off WIDTH */
  assign inst = mem[pc[31:2]];
  /* verilator lint_on WIDTH */
endmodule
