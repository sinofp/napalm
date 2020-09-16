`timescale 1ns / 1ps


module if_id(
           input             clk,
           input             rst,
           input [31:0]      inst_next,
           output reg [31:0] inst_now
       );

always @(posedge clk) begin
    if (rst) begin
        inst_now <= 32'b0;
    end
    else begin
        inst_now <= inst_next;
    end
end
endmodule
