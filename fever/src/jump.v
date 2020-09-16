`timescale 1ns / 1ps

module jump(
		input clk,
		input[31:0] pc,
		input[1:0] jumpOp,
		input[25:0] imm26,
		input[15:0] imm16,

		output reg[31:0] jpc
	);

always @( posedge clk ) begin
	if(jumpOp == 2'b01 || 2'b00) begin
		jpc <= (pc + 32'h1);// +4
	end
	else if (jumpOp == 2'b10) begin
		jpc <= (({pc[31:28], imm26, 2'b00} & 32'h000007ff) >> 2);// J
	end
	else if (jumpOp == 2'b11) begin
		jpc <= {(pc + 32'h1) + ({{14{imm16[15]}}, {imm16, 2'b00}} >> 2)};// BEQ
	end
end

endmodule