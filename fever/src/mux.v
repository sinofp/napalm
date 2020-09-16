`timescale 1ns / 1ps

// to register pile
module mux1 (				
		input[4:0] regT,
		input[4:0] regD,
		input writeReg,

		output[4:0] res
	);

assign res = (writeReg == 1'b1) ? regD : regT;
endmodule

// to ALU
module mux2 (
		input[31:0] resExtend,
		input[31:0] reg2Data,
		input srcALU,

		output[31:0] res
	);

assign res = (srcALU == 1'b0) ? reg2Data :
			 resExtend;
endmodule

//from data memory
module mux3 (
		input[31:0] aluRes,
		input[31:0] memReadData,
		input[31:0] resExtend,
		input[1:0] srcReg,

		output[31:0] res
	);
assign res = (srcReg == 2'b00 || srcReg == 2'b10) ? aluRes :
			 (srcReg == 2'b01) ? resExtend :
			 memReadData ;
endmodule
