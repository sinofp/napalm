`timescale 1ns / 1ps


module memory (
    input clk,
    input rst,
    input [31:0] _rd2,  // 要写入的数据
    input _mem_we,  // 要写入么�?
    input [31:0] _alu_res,  // alu的运算结果，同时也是访存的地�?
    input [4:0] _reg_write_addr,  // 给写回阶段的，写回到哪个寄存�?--reg_file.wa
    input [31:0] _pcp8,
    input [5:0] _op_code,
    input _reg_we,
    input [2:0] _reg_wd_mux,
    input [31:0] _imm_ext,
    output reg_we,
    output [31:0] mem_data,  // 读出的数�?
    output reg[31:0] alu_res,
    output [31:0] imm_ext,
    output [2:0] reg_wd_mux,
    output [31:0] pcp8,
    output reg [4:0] reg_write_addr  // 给写回的，和_reg_write_addr差一个周�?
);
  reg [5:0] op_code;
  reg [31:0] rd2;
  reg mem_we;
  always @(posedge clk) begin
    if (rst) begin
      alu_res <= 32'b0;
      reg_write_addr <= 5'b0;
      rd2 <= 32'b0;
      mem_we <= 1'b0;
      op_code <= 6'b0;
    end else begin
      alu_res <= _alu_res;
      reg_write_addr <= _reg_write_addr;
      rd2 <= _rd2;
      mem_we <= _mem_we;
      op_code <= _op_code;
    end
  end

  data_mem DATA_MEM (
      .clk (clk),
      ._addr(alu_res),
      ._wd (rd2),
      ._we  (mem_we),
      .rd  (mem_data),
      ._opcode(op_code)
  );

endmodule  // memory
