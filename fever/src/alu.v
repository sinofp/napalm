`timescale 1ns / 1ps

module alu(
		input[31:0] src1,
		input[31:0] src2,
		input[1:0] op,
		output[31:0] res,
		output zeroRes
	);

assign res = (op == 2'b01) ? (src1 + src2) :	// + 
			 (op == 2'b10) ? (src1 - src2) : 	// -
			 (src1 | src2) ; 	// or

assign zeroRes = (res == 0) ? 1'b1 : 1'b0;

endmodule