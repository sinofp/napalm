`timescale 1ns / 1ps

`define instMemSize 1023

module instructionMemory(
		input clk, 
		input[31:0] pc,
		output[31:0] instruction
	);

reg[31:0] instMemory[`instMemSize:0];	// storage

assign instruction = instMemory[pc];	// get instruction from memory

endmodule