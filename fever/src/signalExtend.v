`timescale 1ns / 1ps

module signalExtend (
		input[15:0] imm16,
		input[1:0] extendOp,

		output[31:0] extendRes
	);

assign extendRes = (extendOp == 2'b01) ? {imm16, 16'b0} :
				   (extendOp == 2'b10) ? {{16{imm16[15]}}, imm16} :
				   {16'b0, imm16} ;

endmodule