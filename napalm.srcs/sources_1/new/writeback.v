`timescale 1ns / 1ps
`include "def.vh"


module writeback (
    input             clk,
    input             rst,
    input      [31:0] _mem_data,  // 从内存中读出的数�?
    input      [31:0] _alu_res,  // 从alu得到的结�?
    input      [31:0] _imm_ext,  // lui的立即数
    input      [31:0] _pcp8,  // 跳转的link addr
    input      [ 2:0] _reg_wd_mux,  // cu的srcReg，用上面哪个数据写回
    input      [ 4:0] _reg_write_addr,  // 写到哪个寄存�?
    input             _reg_we,  // write enable
    output reg        reg_we,
    output reg [ 4:0] reg_write_addr,  // 同上，但慢一个周�?
    output     [31:0] reg_write_data
);

  reg [31:0] mem_data, alu_res, imm_ext, pcp8;
  reg [2:0] reg_wd_mux;

  always @(posedge clk) begin
    if (rst) begin
      reg_we <= 0;  // 别写入就得了，剩下数据随�?
    end else begin
      reg_we <= _reg_we;
      mem_data <= _mem_data;
      alu_res <= _alu_res;
      imm_ext <= _imm_ext;
      pcp8 <= _pcp8;
      reg_wd_mux <= _reg_wd_mux;
      reg_write_addr <= _reg_write_addr;
    end
  end

  assign reg_write_data = (reg_wd_mux == `SRC_WRITE_REG_IMM)? imm_ext:
                    (reg_wd_mux == `SRC_WRITE_REG_ALU)? alu_res:
                    (reg_wd_mux == `SRC_WRITE_REG_MEM)? mem_data:
                    (reg_wd_mux == `SRC_WRITE_REG_MEM)? mem_data:
                    (reg_wd_mux == `SRC_WRITE_REG_JDST)? pcp8:
                    32'bx; // 不应该有这种情况--或�?�说这种情况并不用写�?
  //TODO 给decode的register file
endmodule  // writeback
