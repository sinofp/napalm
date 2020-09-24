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

  integer f;

  initial begin
    $readmemh("../../../../test/reg.txt", CPU.DECODE.REG_FILE.gpr);
    $readmemb("../../../../test/data.txt", CPU.MEMORY.DATA_MEM.mem);
    $readmemh("../../../../test/branch.txt", CPU.FETCH.INST_MEM.mem);

    f = $fopen("../../../../test/reg_log.txt", "w");
  end

  initial begin
    #1 clk = 1'bx;
    rst_n = 1'bx;
    #(CLK_PERIOD / 4) clk = 1'b1;  // 0.25周期时，clk=1�?0.5周期=0�?1周期时为posedge
    rst_n = 1'b0;  // 第一个posedge时，rst为低电平→初始化pc
    clk = 1'b1;  // start
    #(CLK_PERIOD / 2) rst_n = 1'bx;  // 保证之后的posedge clk，rst无效
    #(CLK_PERIOD * 200) $stop;
  end

  wire [31:0] lpc = {2'b0, CPU.FETCH.pc_now[31:2]};

  localparam PC_END = 32'h4 + 32'd10;

  always @(posedge clk) begin
    if (lpc > 32'h4 & lpc <= PC_END) begin
      $fdisplay(f, "inst: %x", CPU.FETCH.INST_MEM.mem[lpc - 32'h5]);
      $fdisplay(f, "t0 = %x", CPU.DECODE.REG_FILE.gpr[8]);
      $fdisplay(f, "t1 = %x", CPU.DECODE.REG_FILE.gpr[9]);
      $fdisplay(f, "t2 = %x", CPU.DECODE.REG_FILE.gpr[10]);
      $fdisplay(f, "t3 = %x", CPU.DECODE.REG_FILE.gpr[11]);
      $fdisplay(f, "t4 = %x", CPU.DECODE.REG_FILE.gpr[12]);
      $fdisplay(f, "t5 = %x", CPU.DECODE.REG_FILE.gpr[13]);
      $fdisplay(f, "t6 = %x", CPU.DECODE.REG_FILE.gpr[14]);
      $fdisplay(f, "t7 = %x", CPU.DECODE.REG_FILE.gpr[15]);
      $fdisplay(f, "t8 = %x", CPU.DECODE.REG_FILE.gpr[24]);
      $fdisplay(f, "t9 = %x", CPU.DECODE.REG_FILE.gpr[25]);
      $fdisplay(f, "=========================");
    end
    if (lpc == PC_END) begin
      $fclose(f);
    end
  end
endmodule
