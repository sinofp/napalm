`timescale 1ns / 1ps

//--------------------------------------
/*  Instructions' OP & Function Code  */
`define NOOP 32'b0

// I Type
`define ADDI_OP 		6'b001000
`define ADDIU_OP 		6'b001001 
`define ANDI_OP 		6'b001100
`define BEQ_OP 			6'b000100
`define BRANCH_OP 		6'b000001			// Still need to be distinguished
`define BGTZ_OP 		6'b000111
`define BLEZ_OP 		6'b000110
`define BNE_OP 			6'b000101
`define LB_OP 			6'b100000
`define LUI_OP			6'b001111
`define LW_OP 			6'b100011
`define ORI_OP 			6'b001101
`define SB_OP 			6'b101000
`define SLTI_OP 		6'b001010
`define SLTIU_OP 		6'b001011
`define SW_OP 			6'b101011
`define XORI_OP 		6'b001110

// R Type 
`define R_OP 			6'b000000
`define ADD_FUNC 		6'b100000
`define ADDU_FUNC 		6'b100001 
`define AND_FUNC 		6'b100100 
`define JR_FUNC 		6'b001000
`define OR_FUNC 		6'b100101
`define SLL_FUNC 		6'b000000
`define SLLV_FUNC 		6'b000100
`define SLT_FUNC 		6'b101010
`define SLTU_FUNC 		6'b101011
`define SRA_FUNC 		6'b000011
`define SRL_FUNC 		6'b000010
`define SRLV_FUNC		6'b000110
`define SUB_FUNC 		6'b100010
`define SUBU_FUNC 		6'b100011
`define XOR_FUNC 		6'b100110
`define NOR_FUNC 		6'b100111
`define DIV_FUNC 		6'b011010
`define DIVU_FUNC 		6'b011011
`define MFHI_FUNC 		6'b010000
`define MFLO_FUNC 		6'b010010
`define MULT_FUNC 		6'b011000
`define MULTU_FUNC 		6'b011001

// J Type
`define J_OP 			6'b000010
`define JAL_OP 			6'b000011

// BRANCH RT Value
`define BGEZ_RT 		5'b00001
`define BGEZAL_RT 		5'b10001
`define BLTZ_RT 		5'b00000
`define BLTZAL_RT 		5'b10000


//----------------
/* Control Unit */

// Whether write into register
`define WRITE_REG_NO 		1'b0 				// Cannot write into reg
`define WRITE_REG_YES 		1'b1 				// OK to write into reg

// Whether write into memory
`define WRITE_MEM_NO 		1'b0 				// Cannot write into mem
`define WRITE_MEM_YES 		1'b1 				// OK to write into mem

// Source operand of ALU input
`define ALU_SRC_DEFAULT 	1'b0 				// from register
`define ALU_SRC_EXTEND 		1'b1 				// from imm after extension

// Which dst reg to write into
`define WRITE_REG_DST_DEFAULT 	2'b00 			// Default
`define WRITE_REG_DST_RT 		2'b01 			// into rt
`define WRITE_REG_DST_RD 		2'b10 			// into rd
`define WRITE_REG_DST_31 		2'b11 			// into $31

// Extend Situations
`define EXTEND_DEFAULT 			2'b00 			// Default
`define EXTEND_LEFT16 			2'b01 			// <<16
`define EXTEND_S_IMM32 			2'b10 			// Signed extend
`define EXTEND_U_OFF32 			2'b11 			// Unsigned extend

// Jump Situations
`define JUMP_OP_DEFAULT 		3'b000 			// Default
`define JUMP_OP_P4 				3'b001 			// PC + 4
`define JUMP_OP_DST 			3'b010 			// PC[31:28] + imm26 + 2'b00
`define JUMP_OP_OFF 			3'b011 			// PC + 4 + OFFSET
`define JUMP_OP_RS 				3'b100 			// RS

// Source of writing into register
`define SRC_WRITE_REG_DEFAULT 	3'b000 			// Default
`define SRC_WRITE_REG_IMM 		3'b001 			// from imm after extension
`define SRC_WRITE_REG_ALU 		3'b010 			// from ALU
`define SRC_WRITE_REG_MEM 		3'b011 			// from Data mem
`define SRC_WRITE_REG_JDST 		3'b100 			// from Jump dest

// ALU Operator
`define ALU_OP_DEFAULT 			4'b0000 		// Default
`define ALU_OP_PLUS 			4'b0001 		// +
`define ALU_OP_AND 				4'b0010 		// &
`define ALU_OP_DIV 				4'b0011 		// / and %
`define ALU_OP_MULT 			4'b0100 		// *
`define ALU_OP_OR 				4'b0101 		// |
`define ALU_OP_SLL 				4'b0110 		// <<
`define ALU_OP_SLT 				4'b0111 		// set on less than
`define ALU_OP_SRA 				4'b1000 		// >>
`define ALU_OP_SRL 				4'b1001 		// >>
`define ALU_OP_SRLV 			4'b1010 		// shift right logical variable
`define ALU_OP_MINUS 			4'b1011 		// -
`define ALU_OP_XOR 				4'b1100 		// xor
`define ALU_OP_NOR 				4'b1101 		// nor
`define ALU_OP_SLLV 			4'b1110 		// shift left logical variable

// BR UNIT OP
`define BR_OP_LEN  				4
`define BR_OP_DEFAULT 			4'b0000			// nothing to do
`define BR_OP_DIRECTJUMP		4'b0001			// nothing special
`define BR_OP_GREATER			4'b0010			// >
`define BR_OP_GREATER_EQ		4'b0011			// >=
`define BR_OP_EQUAL				4'b0100			// ==
`define BR_OP_NOT_EQUAL			4'b0101			// !=
`define BR_OP_LESS				4'b0110			// <
`define BR_OP_LESS_EQ			4'b0111			// <=
`define BR_OP_REG				4'b1000 		// for jr
// todo

`define FORWARD_DEFAULT 2'b00
`define FORWARD_EXE 2'b01
`define FORWARD_MEM 2'b10
`define FORWARD_WB 2'b11
