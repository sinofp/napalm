`timescale 1ns / 1ps


module memory (
    input clk,
    input rst,
    input [31:0] rd2,  // 要写入的数据
    input mem_we,  // 要写入么？
    input [31:0] alu_res,  // alu的运算结果，同时也是访存的地址
    input [4:0] reg_write_addr,  // 给写回阶段的，写回到哪个寄存器——reg_file.wa
	
    output reg [31:0] mem_data,  // 读出的数据
    output reg [4:0] reg_wa  // 给写回的，和_reg_wa_m差一个周期
);

  reg [31:0] wd, res;
  reg mem_we;

  always @(posedge clk) begin
    if (rst) begin
      res <= 32'b0;
      reg_wa <= 5'b0;
      wd <= 32'b0;
      mem_we <= 1'b0;
    end else begin
      res <= alu_res;
      reg_wa <= reg_write_addr;
      wd <= rd2;
      mem_we <= mem_we;
    end
  end

  data_mem DATA_MEM (
      .clk (clk),
      .addr(res),
      .wd  (wd),
      .we  (mem_we),
      .rd  (mem_data)
  );

endmodule  // memory
