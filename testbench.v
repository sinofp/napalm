`timescale 1ns / 1ps
module testbench();

reg clk;
reg rst;

top _TOP(.clk(clk), .rst(rst));

initial begin
	$readmemh("C:/Users/Fever/singleCycleCPU/singleCycleCPU.srcs/sim_1/mem/instruction.txt", _TOP._IM.instMemory);
	$readmemh("C:/Users/Fever/singleCycleCPU/singleCycleCPU.srcs/sim_1/mem/data.txt", _TOP._DM.dataMem);
	$readmemh("C:/Users/Fever/singleCycleCPU/singleCycleCPU.srcs/sim_1/mem/reg.txt", _TOP._RP.register);

	clk = 0;
	rst = 1;

	#20 rst = 0;
	#300 $stop;
end

always 
	#10
	clk = ~clk;
endmodule