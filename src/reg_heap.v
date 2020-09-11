`timescale 1ns / 1ps
module reg_heap (
           input clk,
           input[4:0] ra1,
           input[4:0] ra2,
           input[4:0] wa,
           input we,
           input[31:0] wd,
           output[31:0] rd1,
           output[31:0] rd2
       );

reg[31:0] gpr[31:0];

assign rd1 = (ra1 == 5'b0)? 32'b0: gpr[ra1];
assign rd2 = (ra2 == 5'b0)? 32'b0: gpr[ra2];

always @(posedge clk) begin
    if (we) begin
        gpr[wa] <= wd;
    end
end
endmodule
