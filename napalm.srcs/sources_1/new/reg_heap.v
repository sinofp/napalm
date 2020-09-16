`timescale 1ns / 1ps


module reg_heap(
           input         clk,
           input [4:0]   ra1,
           input [4:0]   ra2,
           input [4:0]   wa,
           input         we,
           input [31:0]  wd,
           output [31:0] rd1,
           output [31:0] rd2
       );

reg[31:1] gpr;
reg [1:0] hilo;

always @ (posedge clk) begin
    if (we & wa != 5'b0) begin
        gpr[wa] <= wd;
    end
end

endmodule
