`timescale 1ns / 1ps
module testbench;
reg clk;
reg rst_n;

top TOP(.clk(clk), .rst_n(rst_n));

localparam CLK_PERIOD = 4'ha;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $readmemh("../../../../sim/reg.txt", TOP.REG_HEAP.gpr);
    $readmemb("../../../../sim/data.txt", TOP.DATA_MEM.mem);
    $readmemh("../../../../sim/inst.txt", TOP.INST_MEM.mem);
end

initial begin
    #1
    clk = 1'bx;
    rst_n = 1'bx;
    #(CLK_PERIOD/4)
    clk = 1'b1; // 0.25周期时，clk=1→0.5周期=0→1周期时为posedge
    rst_n = 1'b0; // 第一个posedge时，rst为低电平→初始化pc
    clk = 1'b1; // start
    #(CLK_PERIOD/2)
    rst_n = 1'bx; // 保证之后的posedge clk，rst无效
    #(CLK_PERIOD*200)
    $stop;
end
endmodule
