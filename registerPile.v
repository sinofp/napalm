`timescale 1ns / 1ps

module registerPile (
		input clk, 
		input[4:0] srcReg1Addr,
		input[4:0] srcReg2Addr,
		input[4:0] writeRegAddr,
		input regWriteEnable,
		input[31:0] writeData,

		output[31:0] reg1Data, 
		output[31:0] reg2Data
	);

reg[31:0] register[31:0];

assign reg1Data = (srcReg1Addr == 5'b0) ? 32'b0 : register[srcReg1Addr];
assign reg2Data = (srcReg2Addr == 5'b0) ? 32'b0 : register[srcReg2Addr];

always @(posedge clk) begin
	if (regWriteEnable) begin
		register[writeRegAddr] <= writeData;
	end
end
endmodule