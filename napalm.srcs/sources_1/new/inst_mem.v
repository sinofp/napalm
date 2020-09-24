`timescale 1ns / 1ps


module inst_mem (
    input         clk,
    input  [31:0] pc,
    output [31:0] inst
);

  reg [31:0] mem[127:0];

  initial begin
    // addi $t0, $0, 100
    // addi $t1, $0, 0
    // loop:
    // addi $t1, $t1, 1
    // blt $t1, $0, loop
    // sw $t1, 0($0)
    mem[0] = 32'h20080064;
    mem[1] = 32'h20090000;
    mem[2] = 32'h21290001;
    mem[3] = 32'h1528fffe;
    mem[4] = 32'hac090000;
  end

  assign inst = mem[{2'b0, pc[31:2]}];
endmodule
