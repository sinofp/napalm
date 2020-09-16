`timescale 1ns / 1ps

// Source of writing into register
`define SRC_DEFAULT 2'b00
`define SRC_IMM		2'b01
`define SRC_ALU 	2'b10
`define SRC_MEM		2'b11

// ALU OP
`define ALU_OP_DEFAULT 	2'b00
`define ALU_OP_PLUS		2'b01 
`define ALU_OP_MINUS	2'b10
`define ALU_OP_OR		2'b11

// Whether write into memory
`define W_MEM_NO	1'b0
`define W_MEM_YES	1'b1

// Whether write into register
`define W_REG_NO 	1'b0
`define W_REG_YES 	1'b1

// Source operator of ALU input
`define ALU_SRC_DEFAULT	1'b0
`define ALU_SRC_EXTEND	1'b1

// Writing Destination Register
`define W_REG_RT	1'b0
`define W_REG_RD	1'b1

// Extend Situations
`define EXTEND_DEFAULT	2'b00
`define EXTEND_LEFT16	2'b01
`define EXTEND_S_IMM32	2'b10
`define EXTEND_U_OFF32	2'b11

// Jump situations
`define JUMP_OP_DEFAULT 2'b00
`define JUMP_OP_P4	 	2'b01
`define JUMP_OP_J		2'b10
`define JUMP_OP_BEQ		2'b11

// I Type
`define LUI_OP 		6'b001111
`define	ADDUI_OP	6'b001001
`define LW_OP 		6'b100011
`define SW_OP		6'b101011
`define BEQ_OP		6'b000100
// R Type
`define R_OP		6'b000000
`define ADD_FUNC	6'b100000
`define OR_FUNC		6'b100101
// J Type
`define J_OP		6'b000010


module controlUnit(
		input[5:0] opcode,			// Opcode[ 31 : 26 ]
 		input[5:0] rFunc,			// R-Instructions Function
		input zeroRes,				// if ALU result = 0

		output[1:0] jumpOp,			// For JUMP
		output[1:0] extendOp,		// For Signal Extend
		output regWriteEn,			// For Register File
		output memWriteEn,			// For Data Memory
		output[1:0] aluOp,			// For ALU
		output writeReg,			// FOR MUX1
		output srcAlu,				// FOR MUX2
		output[1:0] srcReg			// FOR MUX3
	);

wire lui, addiu, add, lw, sw, beq, j, rTemp, _or;

// R Instruction
assign rTemp 	= (opcode == `R_OP) 			? 1 : 0;
assign add 		= (rTemp && rFunc == `ADD_FUNC) ? 1 : 0;
assign _or 		= (rTemp && rFunc == `OR_FUNC)  ? 1 : 0;
// I Instruction
assign lui 		= (opcode == `LUI_OP) 			? 1 : 0;
assign addiu 	= (opcode == `ADDUI_OP) 		? 1 : 0;
assign lw 		= (opcode == `LW_OP) 			? 1 : 0;
assign sw 		= (opcode == `SW_OP) 			? 1 : 0;
assign beq 		= (opcode == `BEQ_OP) 			? 1 : 0;
// J Instruction
assign j 		= (opcode == `J_OP) 			? 1 : 0;

// Control Signals
assign jumpOp = (lui|| addiu|| add|| lw|| sw|| _or) ? `JUMP_OP_P4 :
				(beq && !zeroRes) ? `JUMP_OP_P4 :
				(beq && zeroRes) ? `JUMP_OP_BEQ :
				(j) ? `JUMP_OP_J : 
				`JUMP_OP_P4;

assign extendOp = (lui) ? `EXTEND_LEFT16 :
				  (lw || sw) ? `EXTEND_U_OFF32 :
				  (addiu) ? `EXTEND_S_IMM32 :
				  `EXTEND_DEFAULT;

assign regWriteEn = (lui|| addiu|| add|| lw|| rTemp|| _or) ? `W_REG_YES : 
					`W_REG_NO;

assign memWriteEn = (sw) ? `W_MEM_YES : 
					`W_MEM_NO;

assign aluOp = (addiu|| add|| lw|| sw) ? `ALU_OP_PLUS :
			   (beq) ? `ALU_OP_MINUS :
			   (_or) ? `ALU_OP_OR :
			   `ALU_OP_DEFAULT;

assign writeReg = (add|| _or) ? `W_REG_RD : `W_REG_RT;

assign srcAlu = (addiu|| lw|| sw) ? `ALU_SRC_EXTEND : 
				`ALU_SRC_DEFAULT;

assign srcReg = (lui) ? `SRC_IMM :
				(addiu|| add|| _or) ? `SRC_ALU :
				(lw) ? `SRC_MEM :
				`SRC_DEFAULT; 

endmodule





















