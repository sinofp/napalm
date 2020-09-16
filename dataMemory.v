`timescale 1ns / 1ps

`define dataMemSize 1023

module dataMemory (
		input clk,
		input writeEnable,
		input[31:0] memAddr,
		input[31:0] writeData,
		
		output[31:0] readData
	);

reg[31:0] dataMem[`dataMemSize:0];

assign readData = dataMem[(memAddr >> 2)];

always @(posedge clk ) begin
	if (writeEnable) begin     // write permission
		dataMem[(memAddr >> 2)] <= writeData;
	end
end

endmodule