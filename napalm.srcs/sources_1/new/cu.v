`timescale 1ns / 1ps
`include "def.vh"

module cu (
    input [31:0] _inst,

    //output [1:0] extend_op,                 // For Signal Extend
    output       reg_we,  // For Register File
    output       mem_we,  // For Data Memory
    output [3:0] alu_op,  // For ALU
    output [1:0] write_reg_dst,  // FOR MUX before register heap
    output [1:0] alu_src,  // FOR MUX before ALU
    output [2:0] reg_write_data_mux,  // FOR MUX after Data Memory

    output [`BR_OP_LEN - 1 : 0] br_op,  // for br_unit
    output [              31:0] imm_ext  // imm after extension
);

  wire [5:0] opcode = _inst[31:26];
  wire [5:0] rFunc = _inst[5:0];
  wire [4:0] rt = _inst[20:16];

  wire rTemp;
  // R
  wire add_inst, addu_inst, and_inst, jr_inst, or_inst, sll_inst, sllv_inst, slt_inst, sltu_inst, sra_inst, srl_inst, srlv_inst, sub_inst, subu_inst, xor_inst, nor_inst, div_inst, divu_inst, mfhi_inst, mflo_inst, mult_inst, multu_inst;
  // I
  wire addi_inst, addiu_inst, andi_inst, beq_inst, bgtz_inst, blez_inst, bne_inst, lb_inst, lui_inst, lw_inst, ori_inst, sb_inst, slti_inst, sltiu_inst, sw_inst, xori_inst;
  // J
  wire j_inst, jal_inst;
  // branch
  wire bgez_inst, bgezal_inst, bltz_inst, bltzal_inst, branch_inst;
  // NOP
  wire nop_inst;


  // to extend imm26 for J
  //assign imm26Ext = {6'b0, inst[25:0]};

  // for shift imm
  // assign sa = inst[10:6];

  // for noop
  assign nop_inst = (_inst == 32'b0) ? 1 : 0;

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
  assign multu_inst = (rTemp && rFunc == `MULTU_FUNC) ? 1 : 0;

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

  /* Control Signals */

  // // extendOp
  // assign extend_op = (lui_inst) ? `EXTEND_LEFT16 :
  // 		  (addi_inst|| addiu_inst|| slti_inst|| sltiu_inst|| lb_inst|| lw_inst|| sb_inst) ? `EXTEND_S_IMM32 :
  // 		  (andi_inst|| ori_inst  || xori_inst) ? `EXTEND_U_OFF32 :
  //         (sll_inst || sra_inst  || srl_inst ) ? 
  // 		  `EXTEND_DEFAULT;

  assign imm_ext = (lui_inst) ? {_inst[15:0], 16'b0} :
                   (addi_inst|| addiu_inst|| slti_inst|| sltiu_inst|| lb_inst|| lw_inst|| sb_inst) ? {{16{_inst[15]}}, _inst[15:0]} :
                   (andi_inst|| ori_inst  || xori_inst) ? {16'b0, _inst[15:0]} :
                   (sll_inst || sra_inst  || srl_inst ) ? {27'b0, _inst[10:6]} :
                   32'b0;

  // Register Write Enable
  assign reg_we = (add_inst || addi_inst|| addiu_inst|| addu_inst|| and_inst || andi_inst|| jal_inst || 
					          lb_inst  || lui_inst || lw_inst   || or_inst  || ori_inst || sll_inst || sllv_inst|| 
					          slt_inst || slti_inst|| sltiu_inst|| sltu_inst|| sra_inst || srl_inst || srlv_inst|| 
					          sub_inst || subu_inst|| xor_inst  || nor_inst || xori_inst|| div_inst || divu_inst|| 
					          mfhi_inst|| mflo_inst|| mult_inst || multu_inst ) ? 1'b1 : 1'b0;

  // Memory Write Enable
  assign mem_we = (sb_inst || sw_inst) ? 1'b1 : 1'b0;

  // ALU operator
  assign alu_op = (add_inst|| addi_inst|| addiu_inst|| addu_inst|| lb_inst|| lw_inst|| sb_inst|| sw_inst) ? `ALU_OP_PLUS :
			            (and_inst|| andi_inst) ? `ALU_OP_AND :
			            (div_inst|| divu_inst) ? `ALU_OP_DIV :
			            (mult_inst|| multu_inst) ? `ALU_OP_MULT :
			            (or_inst|| ori_inst) ? `ALU_OP_OR :
			            (sll_inst) ? `ALU_OP_SLL :
			            (slt_inst|| slti_inst|| sltu_inst|| sltiu_inst) ? `ALU_OP_SLT :
			            (sra_inst) ? `ALU_OP_SRA :
			            (srl_inst) ? `ALU_OP_SRL :
			            (srlv_inst) ? `ALU_OP_SRLV :
			            (sub_inst|| subu_inst|| beq_inst) ? `ALU_OP_MINUS :
			            (xor_inst|| xori_inst) ? `ALU_OP_XOR :
			            (nor_inst) ? `ALU_OP_NOR :
			            (sllv_inst) ? `ALU_OP_SLLV :
			            `ALU_OP_DEFAULT ;

  // Which reg to write into
  assign write_reg_dst = // RD
					 (add_inst || addu_inst || and_inst|| mfhi_inst|| mflo_inst|| or_inst|| 
					  sll_inst || sllv_inst || slt_inst|| sltu_inst|| sra_inst|| srl_inst|| 
					  srlv_inst|| sub_inst  || subu_inst|| xor_inst || nor_inst) ? `WRITE_REG_DST_RD :
					 // RT
					 (addi_inst|| addiu_inst|| andi_inst|| lb_inst|| lui_inst|| lw_inst|| 
					  ori_inst || xori_inst) ? `WRITE_REG_DST_RT :
					 // $31
					 (bgezal_inst|| bltzal_inst|| jal_inst) ? `WRITE_REG_DST_31 :
					 `WRITE_REG_DST_DEFAULT;

  assign alu_src = (addi_inst|| addiu_inst|| slti_inst|| sltiu_inst|| lb_inst|| 
				            lw_inst  || sb_inst   || sw_inst  ||andi_inst || ori_inst  || xori_inst) ? `ALU_SRC_EXTEND :
                    (sll_inst || srl_inst || sra_inst) ? `ALU_SRC_SHAMT :
				            `ALU_SRC_DEFAULT;

  assign reg_write_data_mux = (lui_inst) ? `SRC_WRITE_REG_IMM :	
				                      (addi_inst|| addiu_inst|| andi_inst|| sltiu_inst|| ori_inst|| xori_inst||
				                       add_inst || addu_inst || sub_inst || subu_inst || slt_inst|| sltu_inst|| 
				                       and_inst || or_inst   || nor_inst || xor_inst  || sll_inst|| srl_inst || 
				                       sra_inst || sllv_inst || srlv_inst) ? `SRC_WRITE_REG_ALU:
				                      (lw_inst | lb_inst) ? `SRC_WRITE_REG_MEM :
				                      (jal_inst) ? `SRC_WRITE_REG_JDST :
				                      `SRC_WRITE_REG_DEFAULT ;

  assign br_op = (beq_inst) ? `BR_OP_EQUAL :
  				       (bgez_inst || bgezal_inst) ? `BR_OP_GREATER_EQ :
  				       (bgtz_inst) ? `BR_OP_GREATER :
  			         (blez_inst) ? `BR_OP_LESS_EQ :
  				       (bltz_inst || bltzal_inst) ? `BR_OP_LESS :
  				       (bne_inst) ? `BR_OP_NOT_EQUAL :
  				       (j_inst || jal_inst) ? `BR_OP_DIRECTJUMP :
                 (jr_inst) ? `BR_OP_REG :
  				       `BR_OP_DEFAULT;

  // todo
endmodule
