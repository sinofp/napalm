`timescale 1ns / 1ps
`include "def.v"


module cu(
           	input[31:0] inst,

           	output[2:0] jumpOp,			// For NPC
			output[1:0] extendOp,		// For Signal Extend
			output regWriteEn,			// For Register File
			output memWriteEn,			// For Data Memory
			output[3:0] aluOp,			// For ALU
			output writeReg,			// FOR MUX before register heap
			output srcAlu,				// FOR MUX before ALU
			output[2:0] srcReg			// FOR MUX after Data Memory


       );

wire [5:0] opcode = inst[31:26];
wire [5:0] rFunc = inst[5:0];
wire [4:0] rt = inst[20:16];

wire rTemp;
// R
wire add_inst, addu_inst, and_inst, jr_inst, or_inst, sll_inst, sllv_inst, slt_inst, sltu_inst, sra_inst, srl_inst, srlv_inst, sub_inst, subu_inst, xor_inst, nor_inst, div_inst, divu_inst, mfhi_inst, mflo_inst, mult_inst, multu_inst;
// I
wire addi_inst, addiu_inst, andi_inst, beq_inst, bgtz_inst, blez_inst, bne_inst, lb_inst, lui_inst, lw_inst, ori_inst, sb_inst, slti_inst, sltiu_inst, sw_inst, xori_inst;
// J
wire j_inst, jal_inst;
// branch
wire bgez_inst, bgezal_inst, bltz_inst, bltzal_inst;
// NOP
wire nop_inst;

// for noop
assign nop_inst = (inst == 32'b0) ? 1 : 0;

// for R
assign rTemp = (opcode == `R_OP) ? 1 : 0;
assign add_inst = (rTemp && rFunc == `ADD_FUNC) ? 1 : 0;
assign addu_inst = (rTemp && rFunc == `ADDU_FUNC) ? 1 : 0;
assign and_inst = (rTemp && rFunc == `AND_FUNC) ? 1 : 0;
assign jr_inst = (rTemp && rFunc == `JR_FUNC) ? 1 : 0;
assign or_inst = (rTemp && rFunc == `OR_FUNC) ? 1 : 0;
assign sll_inst = (rTemp && rFunc == `SLL_FUNC) ? 1 : 0;
assign sllv_inst = (rTemp && rFunc == `SLLV_FUNC) ? 1 : 0;
assign slt_inst = (rTemp && rFunc == `SLT_FUNC) ? 1 : 0;
assign sltu_inst = (rTemp && rFunc == `SLTU_FUNC) ? 1 : 0;
assign sra_inst = (rTemp && rFunc == `SRA_FUNC) ? 1 : 0;
assign srl_inst = (rTemp && rFunc == `SRL_FUNC) ? 1 : 0;
assign srlv_inst = (rTemp && rFunc == `SRLV_FUNC) ? 1 : 0;
assign sub_inst = (rTemp && rFunc == `SUB_FUNC) ? 1 : 0;
assign subu_inst = (rTemp && rFunc == `SUBU_FUNC) ? 1 : 0;
assign xor_inst = (rTemp && rFunc == `XOR_FUNC) ? 1 : 0;
assign nor_inst = (rTemp && rFunc == `NOR_FUNC) ? 1 : 0;
assign div_inst = (rTemp && rFunc == `DIV_FUNC) ? 1 : 0;
assign divu_inst = (rTemp && rFunc == `DIVU_FUNC) ? 1 : 0;
assign mfhi_inst = (rTemp && rFunc == `MFHI_FUNC) ? 1 : 0;
assign mflo_inst = (rTemp && rFunc == `MFLO_FUNC) ? 1 : 0;
assign mult_inst = (rTemp && rFunc == `MULT_FUNC) ? 1 : 0;
assign multu_inst = (rTemp && rFunc == `MULTI_FUNC) ? 1 : 0;

// for I
assign addi_inst = (opcode == `ADDI_OP) ? 1 : 0;
assign addiu_inst = (opcode == `ADDIU_OP) ? 1 : 0;
assign andi_inst = (opcode == `ANDI_OP) ? 1 : 0;
assign beq_inst = (opcode == `BEQ_OP) ? 1 : 0;
assign branch_inst = (opcode == `BRANCH_OP) ? 1 : 0;
assign bgtz_inst = (opcode == `BGTZ_OP) ? 1 : 0;
assign blez_inst = (opcode == `BLEZ_OP) ? 1 : 0;
assign bne_inst = (opcode == `BNE_OP) ? 1 : 0;
assign lb_inst = (opcode == `LB_OP) ? 1 : 0;
assign lui_inst = (opcode == `LUI_OP) ? 1 : 0;
assign lw_inst = (opcode == `LW_OP) ? 1 : 0;
assign ori_inst = (opcode == `ORI_OP) ? 1 : 0;
assign sb_inst = (opcode == `SB_OP) ? 1 : 0;
assign slti_inst = (opcode == `SLTI_OP) ? 1 : 0;
assign sltiu_inst = (opcode == `SLTIU_OP) ? 1 : 0;
assign sw_inst = (opcode == `SW_OP) ? 1 : 0;
assign xori_inst = (opcode == `XORI_OP) ? 1 : 0;
// branch 
assign bgez_inst = (branch_inst == 1 && rt == `BGEZ_RT) ? 1 : 0;
assign bgezal_inst = (branch_inst == 1 && rt == `BGEZAL_RT) ? 1 : 0;
assign bltz_inst = (branch_inst == 1 && rt == `BLTZ_RT) ? 1 : 0;
assign bltzal_inst = (branch_inst == 1 && rt == `BLTZAL_RT) ? 1 : 0;

// for J
assign j_inst = (opcode == `J_OP) ? 1 : 0;
assign jal_inst = (opcode == `JAL_OP) ? 1 : 0;


endmodule
