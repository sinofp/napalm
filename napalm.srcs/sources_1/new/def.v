`timescale 1ns / 1ps

/*  Instructions' OP & Function Code  */
`define NOOP			32'b0

// I Type
`define ADDI_OP			6'b001000
`define ADDIU_OP  		6'b001001 
`define ANDI_OP			6'b001100
`define BEQ_OP			6'b000100
`define BRANCH_OP		6'b000001			// Still need to be distinguished
`define BGTZ_OP			6'b000111
`define BLEZ_OP			6'b000110
`define BNE_OP			6'b000101
`define LB_OP			6'b100000
`define LUI_OP 			6'b001111
`define LW_OP 			6'b100011
`define ORI_OP			6'b001101
`define SB_OP			6'b101000
`define SLTI_OP			6'b001010
`define SLTIU_OP		6'b001011
`define SW_OP			6'b101011
`define XORI_OP			6'b001110

// R Type 
`define R_OP			6'b000000
`define ADD_FUNC 		6'b100000
`define ADDU_FUNC 		6'b100001 
`define AND_FUNC		6'b100100 
`define JR_FUNC	 		6'b001000
`define OR_FUNC			6'b100101
`define SLL_FUNC		6'b000000
`define SLLV_FUNC		6'b000100
`define SLT_FUNC		6'b101010
`define SLTU_FUNC		6'b101011
`define SRA_FUNC		6'b000011
`define SRL_FUNC		6'b000010
`define SRLV_FUNC		6'b000110
`define SUB_FUNC		6'b100010
`define SUBU_FUNC 		6'b100011
`define XOR_FUNC		6'b100110
`define NOR_FUNC		6'b100111
`define DIV_FUNC		6'b011010
`define	DIVU_FUNC		6'b011011
`define MFHI_FUNC		6'b010000
`define MFLO_FUNC		6'b010010
`define MULT_FUNC		6'b011000
`define MULTU_FUNC		6'b011001

// J Type
`define J_OP			6'b000010
`define JAL_OP			6'b000011

// BRANCH RT Value
`define BGEZ_RT			5'b00001
`define BGEZAL_RT		5'b10001
`define BLTZ_RT			5'b00000
`define BLTZAL_RT		5'b10000