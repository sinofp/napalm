`timescale 1ns / 1ps
module testbench;
  reg clk;
  reg rst_n;

  cpu CPU (
      .clk  (clk),
      .rst_n(rst_n)
  );

  localparam CLK_PERIOD = 4'ha;
  always #(CLK_PERIOD / 2) clk = ~clk;

  initial begin
    $readmemh("../../../../test/reg.txt", CPU.DECODE.REG_FILE.gpr);
    $readmemb("../../../../test/data.txt", CPU.MEMORY.DATA_MEM.mem);
    $readmemh("../../../../test/pipeline.txt", CPU.FETCH.INST_MEM.mem);
  end

  initial begin
    #1 clk = 1'bx;
    rst_n = 1'bx;
    #(CLK_PERIOD / 4) clk = 1'b1;  // 0.25周期时，clk=1→0.5周期=0→1周期时为posedge
    rst_n = 1'b0;  // 第一个posedge时，rst为低电平→初始化pc
    clk = 1'b1;  // start
    #(CLK_PERIOD / 2) rst_n = 1'bx;  // 保证之后的posedge clk，rst无效
    #(CLK_PERIOD * 200) $stop;
  end
endmodule
