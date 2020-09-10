`timescale 1ns / 1ps
module testbench;
reg clk;
reg rst_n;

top TOP(.clk(clk), .rst_n(rst_n));

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $readmemh("reg.txt", TOP.REG_HEAP.gpr);
    $readmemb("data.txt", TOP.DATA_MEM.mem);
    $readmemb("inst.txt", TOP.INST_MEM.mem);
end

initial begin
    #1
    rst_n = 1'bx;
    clk = 1'bx;
    #10
    rst_n = 1'b1; // start
    #200
    $stop;
end
endmodule
