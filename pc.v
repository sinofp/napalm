`timescale 1ns / 1ps

module pc (
		input clk,
		input rst,
		input[31:0] jpc,

		output reg[31:0] pc
	);

always @(posedge clk) begin
	if (rst) begin
		pc <= 32'b0;
	end
	else begin
		pc <= jpc;
	end
end

endmodule