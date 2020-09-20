`timescale 1ns / 1ps


module memory (
    input clk,
    input rst,
    input [31:0] _rd2,  // 要写入的数据
    input _mem_we,  // 要写入么？
    input [31:0] _alu_res,  // alu的运算结果，同时也是访存的地址
    input [4:0] _reg_write_addr,  // 给写回阶段的，写回到哪个寄存器--reg_file.wa
    output reg [31:0] mem_data,  // 读出的数据
    output reg [4:0] reg_write_addr  // 给写回的，和_reg_write_addr差一个周期
);

  reg [31:0] rd2, alu_res;
  reg mem_we;
  always @(posedge clk) begin
    if (rst) begin
      alu_res <= 32'b0;
      reg_write_addr <= 5'b0;
      rd2 <= 32'b0;
      mem_we <= 1'b0;
    end else begin
      alu_res <= _alu_res;
      reg_write_addr <= _reg_write_addr;
      rd2 <= _rd2;
      mem_we <= _mem_we;
    end
  end

  data_mem DATA_MEM (
      .clk (clk),
      .addr(res),
      .rd2  (rd2),
      .we  (mem_we),
      .rd  (mem_data)
  );

endmodule  // memory
