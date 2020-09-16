`timescale 1ns / 1ps

module top (
		input clk,
		input rst
	);

	wire[5:0] op;
	wire[5:0] func;
	wire[31:0] pc;
	wire[31:0] jpc;
	wire[31:0] inst;
	wire[25:0] imm26;
	wire[15:0] imm16;
	wire[4:0] rs;
	wire[4:0] rt;
	wire[4:0] rd;
	wire[31:0] resExtend;
	wire[4:0] mux1Out;
	wire[31:0] reg1Data;
	wire[31:0] reg2Data;
	wire[31:0] mux2Out;
	wire[31:0] aluRes;
	wire[31:0] memReadData;
	wire[31:0] mux3Out;

	wire[1:0] jumpOp;
	wire[1:0] extendOp;
	wire regWriteEn;
	wire writeReg;
	wire srcAlu;
	wire[1:0] aluOp;
	wire[1:0] srcReg;
	wire memWriteEn;
	wire zeroRes;

	assign op = inst[31:26];
	assign func = inst[5:0];
	assign rs = inst[25:21];
	assign rt = inst[20:16];
	assign rd = inst[15:11];
	assign imm16 = inst[15:0];
	assign imm26 = inst[25:0];

	alu _ALU(.src1(reg1Data),
		 	 .src2(mux2Out),
		 	 .op(aluOp),
		 	 .res(aluRes),
		 	 .zeroRes(zeroRes)
		);

	controlUnit _CU(.opcode(op),
					.rFunc(func),
					.zeroRes(zeroRes),
					.jumpOp(jumpOp),
					.extendOp(extendOp),
					.regWriteEn(regWriteEn),
					.memWriteEn(memWriteEn),
					.aluOp(aluOp),
					.writeReg(writeReg),
					.srcAlu(srcAlu),
					.srcReg(srcReg)
		);

	dataMemory _DM(.clk(clk),
				   .writeEnable(memWriteEn),
				   .memAddr(aluRes),
				   .writeData(reg2Data),
				   .readData(memReadData)
		);

	instructionMemory _IM(.pc(pc),
						  .clk(clk),
						  .instruction(inst)
		);

	jump _JP(.clk(clk),
			 .pc(pc),
			 .jumpOp(jumpOp),
			 .imm26(imm26),
			 .imm16(imm16),
			 .jpc(jpc)
		);

	pc _PC(.clk(clk),
		   .rst(rst),
		   .jpc(jpc),
		   .pc(pc)
		);

	registerPile _RP(.clk(clk),
					 .srcReg1Addr(rs),
					 .srcReg2Addr(rt),
					 .writeRegAddr(mux1Out),
					 .regWriteEnable(regWriteEn),
					 .writeData(mux3Out),
					 .reg1Data(reg1Data),
					 .reg2Data(reg2Data)
				);

	mux1 _M1(.regT(rt),
			 .regD(rd),
			 .writeReg(writeReg),
			 .res(mux1Out)
		);

	mux2 _M2(.resExtend(resExtend),
			 .reg2Data(reg2Data),
			 .srcALU(srcAlu),
			 .res(mux2Out)
		);

	mux3 _M3(.aluRes(aluRes),
			 .memReadData(memReadData),
			 .resExtend(resExtend),
			 .srcReg(srcReg),
			 .res(mux3Out)
		);

	signalExtend _SE(.imm16(imm16),
					 .extendOp(extendOp),
					 .extendRes(resExtend)
				);

endmodule




















